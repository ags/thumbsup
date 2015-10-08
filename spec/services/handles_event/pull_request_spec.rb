require 'spec_helper'
require 'services/handles_event/pull_request'

describe HandlesEvent::PullRequest do
  let(:creates_commit_status) { spy(:creates_commit_status) }
  subject(:handles_pr) {
    HandlesEvent::PullRequest.new(
      creates_commit_status: creates_commit_status
    )
  }

  it "creates a pending commit status when the PR is opened" do
    event = {
      "action" => "opened",
      "repository" => {"id" => 123},
      "pull_request" => {"head" => {"sha" => "abc123"}}
    }

    handles_pr.handle(event)

    expect(creates_commit_status).to have_received(:create).with(
      repository_id: 123,
      sha: "abc123",
      state: "pending"
    )
  end

  it "creates a pending commit status when the PR is synchronized" do
    event = {
      "action" => "synchronize",
      "repository" => {"id" => 123},
      "pull_request" => {"head" => {"sha" => "abc123"}}
    }

    handles_pr.handle(event)

    expect(creates_commit_status).to have_received(:create).with(
      repository_id: 123,
      sha: "abc123",
      state: "pending"
    )
  end

  it "does not create a commit status for other PR events" do
    event = {"action" => "closed"}

    handles_pr.handle(event)

    expect(creates_commit_status).not_to have_received(:create)
  end
end
