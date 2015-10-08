require 'spec_helper'
require 'services/creates_commit_status'

describe CreatesCommitStatus do
  it "creates a commit status for the given sha" do
    github_client = spy(:github_client)
    creates_commit_status = CreatesCommitStatus.new(
      github_client: github_client
    )

    creates_commit_status.create(
      repository_id: 123,
      sha: "abc123",
      state: "pending"
    )

    expect(github_client).to have_received(:create_status).
      with(123, "abc123", "pending", context: "code-review")
  end
end
