#!/usr/bin/env ruby
require 'descriptive_statistics/safe'
require 'github_api'
require 'fileutils'
require 'histogram/array'
require_relative 'github/collector'
require_relative 'github/pull_request'
require_relative 'github/loader'
require_relative 'github/displayer'

module Github
  class Client::GitData::Commits
    def get_full(*args)
      arguments(args, required: [:user, :repo, :sha])
      params = arguments.params
      get_request("/repos/#{arguments.user}/#{arguments.repo}/commits/#{arguments.sha}", params)
    end
  end
end


class Analyser
  attr_accessor :data

  def initialize
    self.data = Loader.new.run
  end

  def time_to_merge
    time = time_to_merge_by_repo.values
    time.extend(DescriptiveStatistics)
    time.mean.round
  end

  def time_to_merge_by_repo
    data.collection
      .select{ |repository, prs| prs.any? }
      .map{ |(repository, prs)|
        prs.extend(DescriptiveStatistics)
        [repository, prs.mean(&:time_to_complete_in_minutes).round]
      }.sort_by(&:last).to_h
  end

  def time_to_merge_by_reviewer
    data.collection_by_reviewer
      .select{ |user, prs| prs.any? }
      .map{ |(user, prs)|
        prs.extend(DescriptiveStatistics)
        [user, prs.mean(&:time_to_complete_in_minutes).round]
      }.sort_by(&:last).to_h
  end

  def percent_of_prs_merged_in_under_2_minutes
    all = data.all.map(&:time_to_complete_in_minutes)
    under10 = all.select{ |t| t<2}
    under10.size.to_f / all.size.to_f * 100
  end

  def percent_of_prs_merged_in_under_10_minutes
    all = data.all.map(&:time_to_complete_in_minutes)
    under10 = all.select{ |t| t<10}
    under10.size.to_f / all.size.to_f * 100
  end

  def percent_of_prs_merged_in_under_1_day
    all = data.all.map(&:time_to_complete_in_minutes)
    under10 = all.select{ |t| t<24*60}
    under10.size.to_f / all.size.to_f * 100
  end


end


Collector.new.run if ARGV.first == 'collect'

collection = Loader.new.run.collection
collection.each do |repository, prs|
  puts "Time to merge histograms for #{repository}"
  data = prs.map(&:time_to_complete_in_minutes)
  Displayer.new(data).histogram
end

exit
prs = Loader.new.run.all
puts "Time to merge histograms"
data = prs
  .map(&:time_to_complete_in_minutes)
  .select{ |t| t<3000}
Displayer.new(data).histogram([1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000,2000,3000])

exit

analyser = Analyser.new
puts "Mean time to merge: #{analyser.time_to_merge} mins"

puts "Mean time to merge by repository:"
puts analyser.time_to_merge_by_repo.to_yaml

puts "Mean time to merge by reviewer:"
puts analyser.time_to_merge_by_reviewer.to_yaml
puts "percent_of_prs_merged_in_under_2_minutes #{analyser.percent_of_prs_merged_in_under_2_minutes}"
puts "percent_of_prs_merged_in_under_10_minutes #{analyser.percent_of_prs_merged_in_under_10_minutes}"
puts "percent_of_prs_merged_in_under_1_day #{analyser.percent_of_prs_merged_in_under_1_day}"

Loader.new.run.collection_by_reviewer.each do |reviewer, prs|
  under10 = prs
    .select{ |pr| pr.time_to_complete_in_minutes < 30 }
    .select{ |pr| pr.changes > 20 }
  puts "#{reviewer}: #{under10.size}" if under10.any?
end

Loader.new.run.collection_by_reviewer.each do |reviewer, prs|
  prs
    .select{ |pr| pr.time_to_complete_in_minutes < 30 }
    .each do |pr|
      puts({
        repository: pr.repository,
        pull_request: pr.pull_request,
        lines_changed: pr.changes,
        reviewer: pr.reviewer,
        author: pr.author,
        time_to_merge: pr.time_to_complete_in_minutes
      })
    end
end






