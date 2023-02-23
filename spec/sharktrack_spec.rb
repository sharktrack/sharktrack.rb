# frozen_string_literal: true

RSpec.describe Sharktrack do
  it "has a version number" do
    expect(Sharktrack::VERSION).not_to be nil
  end

  it "can config a service" do
    Sharktrack.configure do |config|
      config.fedex = {
        base_uri: "123"
      }
    end

    expect(Sharktrack.config.fedex[:base_uri]).to be("123")
  end
end
