# GitHub Activity Analyzer

Rails API for analyzing GitHub user activity and repository contributions.

## Setup

• Install Ruby 3.4.5
• Run `bundle install`
• Run `rails server`

## API Usage

**Endpoint:** `GET /api/github_activity/analyze`

**Parameters:**
• `username` - GitHub username (required)

**Example:**
```bash
curl "http://localhost:3000/api/github_activity/analyze?username=octocat"
```

**Response:** Returns JSON with:
• `username` - Analyzed GitHub username
• `user_repos` - All user repositories
• `total_repositories_contributed` - Count of active repos
• `owned_repositories` - User-owned repo names
• `repository_analysis` - Per-repo breakdown with:
  • Total events count
  • Top event types (PushEvent, CreateEvent, etc.)
  • Recent activity with timestamps and details
