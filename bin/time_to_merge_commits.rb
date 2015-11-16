#!/usr/bin/env ruby
require 'date'
require 'time_diff'
require 'descriptive_statistics'

def merge_commits
 `git log --merges --pretty=format:%H`.split(/\s/)
end

def commit_message(sha)
  `git log -1 --pretty=format:"%s" #{sha}`
end

def pr_merge_commits
 merge_commits.select{ |sha| commit_message(sha).match(/(Merge pull)|(into develop)/) }
end

def print_commit(sha)
  puts `git log -1 --pretty=format:"%cn %cD %s" #{sha}`
end

def commit_parents(sha)
  `git log -1 --pretty=format:%P #{sha}`.split(/\s/)
end

def commit_time(sha)
  DateTime.rfc2822(`git log -1 --pretty=format:"%cD" #{sha}`)
end

def commit_author(sha)
  `git log -1 --pretty=format:"%cn" #{sha}`
end

def commit_jira(sha)
  commit_message(sha)[/[A-Z]{2,7}-[0-9]{1,6}/]
end

def merge_base(sha)
  `git merge-base #{commit_parents(sha).join(' ')}`.chomp
end

def commits_in_a_merge(merge_sha)
  `git log --pretty=format:%H #{merge_base(merge_sha)}..#{merge_sha}`
    .split(/\s/)
    .select{ |sha| commit_jira(sha) == commit_jira(merge_sha)}
    .reject{ |sha| sha == merge_sha }
end

def repos
 Dir.glob('/Users/dparkhurst/dev/coef/d360/repos/*') +
 Dir.glob('/Users/dparkhurst/dev/coef/d360api/repos/*') +
 Dir.glob('/Users/dparkhurst/dev/coef/d360api/repos/*') +
 Dir.glob('/Users/dparkhurst/dev/coef/d360api/repos/*') +
 ['/Users/dparkhurst/dev/coef-open-api'] +
 ['/Users/dparkhurst/dev/coef-web-app'] +
 ['/Users/dparkhurst/dev/coef/coef-doc-api/repos/coef-document-api']
end

def commit_age(sha) # in days
  (DateTime.now - commit_time(sha)).to_f
end

def commit_changes(sha)
  changes = `git show --numstat #{sha} --oneline`.split("\n").last.split(/\s+/)
  changes[0].to_i + changes[1].to_i
end

def changes_in_a_merge(merge_sha)
 commits_in_a_merge(merge_sha).sum
end

stats = Hash.new { |hash,key| hash[key] = [] }

repos.each do |repo|
  Dir.chdir(repo)
  `git checkout develop`
  `git pull`
  pr_merge_commits.each do |merge_commit|
    jira = commit_jira(merge_commit)
    next unless jira
    next unless commit_age(merge_commit) < 365
    parents = commit_parents(merge_commit).select{ |sha| jira == commit_jira(sha) }
    next unless parents && parents.any?
    parent_jira = parents.map{ |sha| commit_jira(sha) }
    parent_times = parents.map{ |sha| commit_time(sha) }
    parent = parents[parent_times.index(parent_times.max)]
    diff = (commit_time(merge_commit) - commit_time(parent)).to_f * 24.0 * 60.0
    stats[commit_author(merge_commit)] << diff.round - changes_in_a_merge(merge_commit)
    puts diff.round
    print_commit(merge_commit)
    commits_in_a_merge(merge_commit).each do |sha|
      print_commit(sha)
    end
    puts "\n\n"
  end
end

stats.sort_by{|author,times| times.mean}.each do |(author, times)|
  puts "#{author} merges code on average #{times.mean.round} minutes after committing code #{times}"
end
