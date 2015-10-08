class DeterminesPullRequestSHA
  def initialize(github_client:)
    @github_client = github_client
  end

  def determine(repository_id:, issue_number:)
    pr = @github_client.pull_request(repository_id, issue_number)
    pr["head"]["sha"]
  end
end
