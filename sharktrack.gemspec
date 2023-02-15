# frozen_string_literal: true

require_relative "lib/sharktrack/version"

Gem::Specification.new do |spec|
  spec.name = "sharktrack"
  spec.version = Sharktrack::VERSION
  spec.authors = ["UoooBarry", "Ven0802"]
  spec.email = ["huahua.personal@gmail.com"]

  spec.summary = "Integrate various package tracking services within one gem."
  spec.description = "Integrate various package tracking services, currently support ..."
  spec.homepage = "https://github.com/sharktrack"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sharktrack/sharktrack.rb"
  spec.metadata["changelog_uri"] = "https://github.com/sharktrack/sharktrack.rb"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
