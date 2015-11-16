require 'yaml'

module Jira

  class Loader

    def collection
      @collection ||= {}
    end

    def all
      collection.values.flatten
    end

    def run
      files = Dir["/tmp/jirastats/*"]
      files.each do |filename|
        repository = filename[/[^\/]+?(?=\.yml)/]
        collection[repository] = File.open(filename) { |file| YAML.load(file) }
      end
      self
    end

  end

end