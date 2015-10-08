module HandlesEvent
  class PullRequest
    def initialize(creates_commit_status:)
      @creates_commit_status = creates_commit_status
    end

    def handle(event)
      if ["opened", "synchronize"].include?(event["action"])
        sha = event["pull_request"]["head"]["sha"]
        repository_id = event["repository"]["id"]

        @creates_commit_status.create(
          repository_id: repository_id,
          sha: sha,
          state: "pending"
        )
      end
    end
  end
end
