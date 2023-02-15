# frozen_string_literal: true

RSpec.describe Sharktrack::Response do
  it "can initialized and auto assign paramters to object" do
    res = Sharktrack::Response.new(origin_body: "",
                                   response_format: "json",
                                   courier: "UPS")
    expect(res.courier).to be("UPS")
  end

  it "can parse attributes when response format is supported" do
    res = Sharktrack::Response.new(origin_body: "",
                                   response_format: "json",
                                   courier: "UPS")

    expect(res.attributes.class).to be(Hash)
  end

  it "raise UnsupportedReseponseFormatError when response format is not supported" do
    res = Sharktrack::Response.new(origin_body: "",
                                   response_format: "csv",
                                   courier: "UPS")

    expect do
      res.attributes
    end.to raise_error(Sharktrack::UnsupportedReseponseFormatError)
  end
end
