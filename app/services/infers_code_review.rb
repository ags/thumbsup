class InfersCodeReview
  MATCHER = /(:\+1:)|(:shipit)|(:sheep: it)/

  def passed?(comment)
    !!(MATCHER =~ comment["body"].to_s)
  end
end
