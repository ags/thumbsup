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
    comment = {"body" => ":+1:", "user" => {"id" => 3}}
    allow(infers_code_review).to receive(:passed?)
      .with(comment).and_return(true)
    allow(determines_pull_request_sha).to receive(:determine)
      .with(repository_id: 1, issue_number: 2).and_return("asd123")

    handles_comment.handle({
      "repository" => {"id" => 1},
      "issue" => {"number" => 2, "user" => {"id" => 4}, "pull_request" => {}},
      "comment" => comment
    })

    expect(creates_commit_status).to have_received(:create)
      .with(repository_id: 1, sha: "asd123", state: "success")
  end

  it "does not create a status for a non-passing code reviews" do
    comment = {"body" => ":+1:", "user" => {"id" => 3}}
    allow(infers_code_review).to \
      receive(:passed?).with(comment).and_return(false)

    handles_comment.handle({
      "repository" => {"id" => 1},
      "issue" => {"number" => 2, "user" => {"id" => 4}, "pull_request" => {}},
      "comment" => comment
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

  it "does not create a status when the commenter of the PR is the commenter" do
    comment = {"body" => ":+1:", "user" => {"id" => 3}}
    allow(infers_code_review).to \
      receive(:passed?).with(comment).and_return(true)

    handles_comment.handle({
      "repository" => {"id" => 1},
      "issue" => {"number" => 2, "pull_request" => {}, "user" => {"id" => 3}},
      "comment" => comment
    })

    expect(creates_commit_status).not_to have_received(:create)
  end
end
