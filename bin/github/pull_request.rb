require 'date'

class PullRequest
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

  def time_to_complete_in_minutes
    days = DateTime.parse(completed_at) - DateTime.parse(created_at)
    minutes = days.to_f * 24 * 60
    minutes.floor
  end
end