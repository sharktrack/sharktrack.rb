# frozen_string_literal: true

require "active_support/hash_with_indifferent_access"

RSpec.describe Sharktrack::Response do
  it "can initialized and auto assign paramters to object" do
    res = Sharktrack::Response.new(body: "",
                                   response_format: "json",
                                   courier: "UPS")
    expect(res.courier).to be("UPS")
  end

  it "raise ArugmentError when required params is missing" do
    expect do
      Sharktrack::Response.new
    end.to raise_error(ArgumentError)
  end
end
