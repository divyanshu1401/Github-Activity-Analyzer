class ActivityAnalysisService
  def initialize(username)
    @username = username
    @github_api = GithubApiService.new
  end
  
  def analyze
    # Get user's recent events and repositories
    events = @github_api.get_user_events(@username)
    user_repos = @github_api.get_user_repositories(@username).map { |repo| repo['full_name'] }
    
    # Group events by repository
    repo_activities = group_events_by_repository(events)
    
    # Analyze each repository
    analysis_results = {}
    
    repo_activities.each do |repo_name, repo_events|
      next if repo_events.empty?
      
      # Find 3 most common event types for this repository
      event_type_counts = count_event_types(repo_events)
      top_event_types = event_type_counts.sort_by { |_type, count| -count }.first(3)
      
      # Check if user owns this repository
      is_owned = user_repos.include?(repo_name)
      
      analysis_results[repo_name] = {
        total_events: repo_events.size,
        top_event_types: top_event_types.to_h,
        is_owned: is_owned,
        recent_activity: repo_events.first(5) # Show 5 most recent activities
      }
    end
    
    {
      username: @username,
      user_repos: user_repos,
      total_repositories_contributed: analysis_results.size,
      owned_repositories: analysis_results.select { |_repo, data| data[:is_owned] }.keys,
      repository_analysis: analysis_results,
    }
  rescue => e
    {
      error: e.message,
      username: @username,
      generated_at: Time.current
    }
  end
  
  private
  
  def group_events_by_repository(events)
    repo_activities = {}
    
    events.each do |event|
      repo_name = event.dig('repo', 'name')
      next unless repo_name
      
      repo_activities[repo_name] ||= []
      repo_activities[repo_name] << {
        type: event['type'],
        created_at: event['created_at'],
        payload: simplified_payload(event['payload'])
      }
    end
    repo_activities
  end
  
  def count_event_types(events)
    event_counts = Hash.new(0)
    
    events.each do |event|
      event_counts[event[:type]] += 1
    end
    
    event_counts
  end
  
  def simplified_payload(payload)
    case payload
    when Hash
      # Keep only essential information to avoid clutter
      {
        action: payload['action'],
        size: payload['size'],
        ref: payload['ref'],
        ref_type: payload['ref_type']
      }.compact
    else
      payload
    end
  end
end