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
      # TODO these two methods could be extracted to an 'event' object.
      return unless on_pull_request?(event)
      return if commenter_is_author?(event)

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

    def commenter_is_author?(event)
      event["issue"]["user"]["id"] == event["comment"]["user"]["id"]
    end
  end
end
