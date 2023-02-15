# frozen_string_literal: true

RSpec.describe Sharktrack::Parsers::JsonParser do
  it "can parse empty Object" do
    hash = Sharktrack::Parsers::JsonParser.new("").parse!
    expect(hash.class).to be(Hash)
  end

  it "can parse raw response to hash" do
    hash = Sharktrack::Parsers::JsonParser.new('{"name": "Alice", "age": 30}').parse!
    expect(hash.class).to be(Hash)
  end

  it "raise JSON::ParserError when pass unexpected token " do
    expect do
      Sharktrack::Parsers::JsonParser.new('{"name": "A').parse!
    end.to raise_error(JSON::ParserError)
  end
end
