class InfersCodeReview
  MATCHER = /(:\+1:)|(:shipit)/

  def passed?(comment)
    !!(MATCHER =~ comment["body"].to_s)
  end
end
