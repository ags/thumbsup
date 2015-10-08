require 'spec_helper'
require 'services/handles_event/issue_comment'

describe HandlesEvent::IssueComment do
  let(:creates_commit_status) { spy(:creates_commit_status) }
  let(:determines_pull_request_sha) { double(:determines_pull_request_sha) }
  let(:infers_code_review) { double(:infers_code_review) }

  subject(:handles_comment) {
    HandlesEvent::IssueComment.new(
      creates_commit_status: creates_commit_status,
      determines_pull_request_sha: determines_pull_request_sha,
      infers_code_review: infers_code_review
    )
  }

  it "creates a success status for the PR SHA when a code review pass is infered" do
    allow(infers_code_review).to receive(:passed?)
      .with({"body" => ":+1:"}).and_return(true)

    allow(determines_pull_request_sha).to receive(:determine)
      .with(repository_id: 1, issue_number: 2).and_return("asd123")

    handles_comment.handle({
      "repository" => {"id" => 1},
      "issue" => {"number" => 2, "pull_request" => {}},
      "comment" => {"body" => ":+1:"}
    })

    expect(creates_commit_status).to have_received(:create)
      .with(repository_id: 1, sha: "asd123", state: "success")
  end

  it "does not create a status for a non-passing code reviews" do
    allow(infers_code_review).to \
      receive(:passed?).with({"body" => ":+1:"}).and_return(false)

    handles_comment.handle({
      "repository" => {"id" => 1},
      "issue" => {"number" => 2, "pull_request" => {}},
      "comment" => {"body" => ":+1:"}
    })

    expect(creates_commit_status).not_to have_received(:create)
  end

  it "does not create a status for regular issues" do
    handles_comment.handle({
      "repository" => {"id" => 1},
      "issue" => {"number" => 2},
      "comment" => {"body" => ":+1:"}
    })

    expect(creates_commit_status).not_to have_received(:create)
  end
end
