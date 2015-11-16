require 'date'

module Jira

  class Ticket
    attr_accessor :data

    def initialize(params)
      self.data = params
    end

    def method_missing(method)
      data[method] if data.keys.include?(method)
    end

    def to_s
      "[#{data.map{|k,v| "#{k}: #{v}"}.join(', ')}]"
    end

  end

end