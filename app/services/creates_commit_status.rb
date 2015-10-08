class CreatesCommitStatus
  def initialize(github_client:)
    @github_client = github_client
  end

  def create(repository_id:, sha:, state:)
    @github_client.create_status(
      repository_id,
      sha,
      state,
      context: "code-review"
    )
  end
end
