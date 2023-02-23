# frozen_string_literal: true

require "active_support/hash_with_indifferent_access"

RSpec.describe Sharktrack::HTTPClient do
  it "can build a client by courier name" do
    client = Sharktrack::HTTPClient.build("fedex", credentials: mock_credentials)
    expect(client.class).to be(Sharktrack::Fedex::Client)
  end

  it "can set default format for response" do
    client = Sharktrack::HTTPClient.build("fedex", credentials: mock_credentials)
    expect(client.default_format).to be(:xml)
  end

  private

  def mock_credentials
    { key: 1, password: 1, account: 1, meter: 1 }
  end
end
