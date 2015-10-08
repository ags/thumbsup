module HandlesEvent
  class IssueComment
    def initialize(creates_commit_status:,
                   determines_pull_request_sha:,
                   infers_code_review:)

      @creates_commit_status = creates_commit_status
      @determines_pull_request_sha = determines_pull_request_sha
      @infers_code_review = infers_code_review
    end

    def handle(event)
      return unless on_pull_request?(event)

      repository_id = event["repository"]["id"]
      issue_number = event["issue"]["number"]

      if @infers_code_review.passed?(event["comment"])
        sha = @determines_pull_request_sha.determine(
          repository_id: repository_id,
          issue_number: issue_number
        )

        @creates_commit_status.create(
          repository_id: repository_id,
          sha: sha,
          state: "success"
        )
      end
    end

    private

    def on_pull_request?(event)
      !!event["issue"]["pull_request"]
    end
  end
end
