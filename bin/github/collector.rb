require 'github_api'
require 'fileutils'

class Collector
  def organization
    'square-root'
  end

  def github_credentials
    @credentials ||= File.open('.github.credentials') { |file| YAML.load(file) }
  end

  def github
    @github ||= Github.new(
      basic_auth: "#{github_credentials[:user]}:#{github_credentials[:password]}",
      auto_pagination: true
    )
  end

  def repositories
    @repositories ||= github.repos.list(org: organization)
  end

  def save(name, prs)
    dir = "/tmp/ghstats/"
    FileUtils.mkdir_p(dir)
    File.open("#{dir}/#{name}.yml", 'w') do |file|
      YAML.dump(prs, file)
    end
  end

  def since
    '2015-03-29T00:00:00Z'
  end

  def issue_config(name)
    {
      user: organization,
      repo: name,
      filter: 'all',
      state: 'closed',
      sort: 'created',
      direction: 'desc',
      since: since
    }
  end

  def run
    repositories.each do |repository|
      prs = []

      puts "repository #{repository.name}"

      github.issues.list(issue_config(repository.name)) do |issue|
        puts "issue #{issue.number}"

        events = github.issues.events.list(
          organization,
          repository.name,
          issue_number: issue.number
        )
        event = events.detect{ |event| event.event == 'merged' }
        next unless event

        puts "event #{issue.created_at}"
        break unless Date.parse(issue.created_at) > Date.parse(since)

        commits = github.pull_requests.commits(
          organization,
          repository.name,
          issue.number
        )

        changes = commits.map { |commit|
          github.git_data.commits.get_full(
            organization,
            repository.name,
            commit.sha
          ).stats.total
        }

        prs << PullRequest.new(
          repository: repository.name,
          pull_request: issue.title,
          author: issue.user.login,
          created_at: issue.created_at,
          reviewer: event.actor.login,
          completed_at: event.created_at,
          commits: commits.map(&:sha),
          comments: issue.comments,
          changes: changes.inject(0,:+)
        )

      end

      save(repository.name, prs)

    end

  end

end
