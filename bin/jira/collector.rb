require 'rest-client'
require 'fileutils'
require 'json'
require 'yaml'

module Jira
  class Collector

    def base_url
      'https://square-root.atlassian.net/rest/api/2/'
    end

    def jira_credentials
      @credentials ||= File.open('.jira.credentials') { |file| YAML.load(file) }
    end

    def jira
      @jira ||= RestClient::Resource.new(
        base_url,
        timeout: 600,
        open_timeout: 600,
        user: jira_credentials[:user],
        password: jira_credentials[:password]
      )
    end

    def repositories
      @repositories ||= github.repos.list(org: organization)
    end

    def save(name, data)
      dir = "/tmp/jirastats/"
      FileUtils.mkdir_p(dir)
      File.open("#{dir}/#{name}.yml", 'w') do |file|
        YAML.dump(data, file)
      end
    end

    def fetch(ticket_numbers)

      tickets = ticket_numbers
        .map{ |number|
          puts number
          [number, JSON.parse(jira["issue/#{number}"].get)]
        }
        .reject{ |(number, response)| response['fields']['issuetype']['subtask'] }
        .map{ |(number, response)|
          Ticket.new(
            number: number,
            status: response['fields']['status']['name'],
            implementer: response['fields']['customfield_12710'],
            reviewer: response['fields']['customfield_12711'],
            tester: response['fields']['customfield_12712']
          )
        }

      save('tickets', tickets)

    end

  end

end
