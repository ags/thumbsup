require 'spec_helper'
require 'app'

describe "handling github webhooks" do
  include Rack::Test::Methods
  def app; App; end

  it "responds to 'pull_request' webhooks" do
    stub_request(:post, "https://api.github.com/repositories/35129377/statuses/0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c").
      with(body: "{\"context\":\"code-review\",\"state\":\"pending\"}")

    body = read_fixture("webhooks/pull_request_opened.json")
    headers = {"HTTP_X_GITHUB_EVENT" => "pull_request"}

    post "/webhook", body, headers

    expect(last_response.status).to eq(204)
  end

  it "responds to 'issue_comment' webhooks" do
    stub_request(:get, "https://api.github.com/repositories/43625710/pulls/2").to_return(
      status: 200,
      body: "{\"base\":{\"sha\":\"0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c\"}}",
      headers: {"Content-Type"=> "application/json"}
    )

    stub_request(:post, "https://api.github.com/repositories/43625710/statuses/0d1a26e67d8f5eaf1f6ba5c57fc3c7d91ac0fd1c").
      with(body: "{\"context\":\"code-review\",\"state\":\"success\"}")

    body = read_fixture("webhooks/issue_comment.json")
    headers = {"X-Github-Event" => "issue_comment"}

    post "/webhook", body, headers

    expect(last_response.status).to eq(204)
  end

  it "acknowledges, but doesn't action other webhooks" do
    body = read_fixture("webhooks/push.json")
    headers = {"HTTP_X_GITHUB_EVENT" => "push"}

    post "/webhook", body, headers

    expect(last_response.status).to eq(204)
  end
end
