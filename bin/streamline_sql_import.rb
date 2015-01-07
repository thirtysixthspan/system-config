#!/usr/bin/env ruby
# Streamline (speed up) import of mysql dumps containing very large
# tables with multiple indexes.
#
# Indexes are removed from all table definitions. Indexes are added
# after all inserts are completed.
#
# usage:
# cat DUMPFILE | ./streamline_sql_import.rb | mysql -uroot DATABASE
#

class Table

  attr_accessor :definition

  def initialize(line)
    @definition = [line]
  end

  def read
    while gets
     @definition << $_
     break if $_.match(/^\) ENGINE=InnoDB.*?;/)
    end
    self
  end

  def name
    @definition.first[/(?<=`).*?(?=`)/]
  end

  def index_lines
    ->(line){ line.match(/^\s+KEY/) }
  end

  def indexes
    @indexes ||= begin
      @indexes = {}
      @definition
        .select(&index_lines)
        .map{ |line| line.match(/KEY `(.*?)`.+?(\(.*\))/) }
        .each{ |match| @indexes[match[1]] = match[2] }
      @indexes
    end
  end

  def add_index_statements
    indexes.map { |key, columns| "ALTER TABLE `#{name}` ADD INDEX `#{key}` #{columns};" }
  end

  def definition_without_indexes
    revised = @definition.reject &index_lines
    revised[-2].gsub!(/,$/,'')
    revised
  end

end

class View

  attr_accessor :definition

  def initialize(line)
    @definition = line
  end

  def name
    @definition.match(/VIEW `(.*?)` AS/)[1]
  end

end

puts <<-EOS
  SET SESSION autocommit=0;
  SET SESSION unique_checks=0;
  SET SESSION foreign_key_checks=0;
  SET SESSION sql_log_bin = 0;
  SET SESSION tx_isolation='READ-UNCOMMITTED';
EOS

tables = []
views = []
while gets
  line = $_
  case
  when line.match(/CREATE TABLE/)
    table = Table.new(line).read
    puts table.definition_without_indexes
    tables << table
  when line.match(/VIEW `.*` AS/)
    view = View.new(line)
    views << view
    puts line
  else
    puts line
  end
end

puts <<-EOS
  COMMIT;
EOS

tables.each do |table|
  puts table.add_index_statements unless views.map(&:name).include?(table.name)
end
