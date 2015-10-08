require 'spec_helper'
require 'services/determines_pull_request_sha'

describe DeterminesPullRequestSHA do
  it "returns the head SHA from GitHub for the repo and issue number" do
    client = double(:github_client)

    allow(client).to receive(:pull_request)
      .with(1, 2).and_return({"head" => {"sha" => "a"}})

    determines = DeterminesPullRequestSHA.new(github_client: client)

    expect(determines.determine(repository_id: 1, issue_number: 2)).to eq("a")
  end
end
