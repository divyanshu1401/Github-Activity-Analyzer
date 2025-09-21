require 'faraday'
require 'json'

class GithubApiService
  BASE_URL = 'https://api.github.com'
  
  def initialize
    @connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :json
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end
  
  # Get user's public events (recent activity)
  def get_user_events(username, per_page: 1000)
    response = @connection.get("/users/#{username}/events/public") do |req|
      req.params['per_page'] = per_page
    end
    
    if response.success?
      response.body
    else
      raise "GitHub API Error: #{response.status} - #{response.body}"
    end
  end
  
  # Get user information
  def get_user(username)
    response = @connection.get("/users/#{username}")
    
    if response.success?
      response.body
    else
      raise "GitHub API Error: #{response.status} - #{response.body}"
    end
  end
  
  # Get repository information
  def get_repository(owner, repo_name)
    response = @connection.get("/repos/#{owner}/#{repo_name}")
    
    if response.success?
      response.body
    else
      raise "GitHub API Error: #{response.status} - #{response.body}"
    end
  end
  
  # Get user's repositories
  def get_user_repositories(username)
    response = @connection.get("/users/#{username}/repos") do |req|
      req.params['type'] = 'all'
      req.params['per_page'] = 100
    end
    
    if response.success?
      response.body
    else
      raise "GitHub API Error: #{response.status} - #{response.body}"
    end
  end
end