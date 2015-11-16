#!/usr/bin/env ruby
require 'yaml'
require 'octokit'


# create ~/.github.credentials file
# ---
# :access_token: your_oauth_token_here
#
# or
#
# ---
# :login: enter_login_here
# :password: enter_password_here

module Github

  class Client

    attr_accessor :user

    def initialize
      client
    end

    def credentials_file
      "#{ENV['HOME']}/.github.credentials"
    end

    def credentials
      return @credentials if @credentials
      fail "#{credentials_file} not found" unless File.exists?(credentials_file)
      @credentials = YAML.load_file(credentials_file)
    end

    def oauth_client
      puts "Accessing Github API via oauth token"
      client = Octokit::Client.new(
        :access_token => credentials[:access_token]
      )
      self.user = client.user
      puts user.login
      client
    end

    def http_auth_client
      puts "Accessing Github API as #{credentials[:login]}"
      client = Octokit::Client.new(
        login: credentials[:login],
        password: credentials[:password]
      )
      self.user = client.user
      puts user.login
      client
    end

    def client
      return @client if @client
      if credentials.include?(:access_token)
        @client = oauth_client
      else
        @client = http_auth_client
      end
    end

    def organization_branch_shas(organization, branch = 'develop')
      puts "Fetching Branch SHAs"
      shas = organization_repositories(organization)
        .map(&:full_name)
        .select{ |repo| client.branch(repo, branch) rescue false }
        .map { |repo| [repo, client.branch(repo, branch).commit.sha] }
      puts Hash[shas].to_yaml
      Hash[shas]
    end

    def method_missing(method, *args, &block)
      client.send(method, *args)
    end

  end

end

#client = Github::Client.new
#client.organization_branch_shas("square-root", "AP-102")


