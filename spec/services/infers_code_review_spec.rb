require 'spec_helper'
require 'services/infers_code_review'

describe InfersCodeReview do
  subject(:code_review) { InfersCodeReview.new }

  it "is passed if it contains a ':+1:'" do
    expect(code_review.passed?({"body" => "foo :+1: bar"})).to eq(true)
  end

  it "is passed if it contains a ':shipit:'" do
    expect(code_review.passed?({"body" => "foo :shipit: bar"})).to eq(true)
  end

  it "did not pass otherwise" do
    expect(code_review.passed?({"body" => "nooope"})).to eq(false)
    expect(code_review.passed?({"body" => ": foo +1 bar :"})).to eq(false)
    expect(code_review.passed?({"body" => ": +1 :"})).to eq(false)
  end
end
