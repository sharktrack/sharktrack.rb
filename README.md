# Sharktrack

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
![ci](https://github.com/sharktrack/sharktrack.rb/actions/workflows/main.yml/badge.svg)

WIP:Integrate various package tracking services

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add sharktrack
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install sharktrack
```

## Usage

Setup in initializers

```ruby
Sharktrack.configure do |config|
    config.fedex = {
        base_uri: "" # base_uri
        credentials: { # Fedex credentials
            key: "",
            account: "",
            password: "",
            meter: "", 
        },
        language: "" # accept 'en' or 'fr'
    }
end
```

Call the api

```ruby
Sharktrack::Fedex.track_by_number('797806677146')
# or merge request with options
Sharktrack::Fedex.track_by_number('797806677146', language: 'fr', credentials: {})
# or create a reusable instance
client = Sharktrack::HTTPClient.build('fedex', options)
client.track_by_number('797806677146')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Format

Any tracking service results should return a `SharkTrack::Response`.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/sharktrack/sharktrack.rb>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sharktrack/sharktrack.rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sharktrack project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sharktrack/blob/main/CODE_OF_CONDUCT.md).
