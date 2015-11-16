require 'yaml'

class Loader

  def collection
    @collection ||= {}
  end

  def collection_by_reviewer
    users = Hash.new { |hash, key| hash[key] = [] }
    collection.each do |_, prs|
      prs.each do |pr|
        users[pr.reviewer] << pr
      end
    end
    users
  end

  def all
    collection.values.flatten
  end

  def run
    files = Dir["/tmp/ghstats/*"]
    files.each do |filename|
      repository = filename[/[^\/]+?(?=\.yml)/]
      collection[repository] = File.open(filename) { |file| YAML.load(file) }
    end
    self
  end

end