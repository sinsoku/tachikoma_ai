# TachikomaAi

[![Build Status](https://travis-ci.org/sinsoku/tachikoma_ai.svg?branch=master)](https://travis-ci.org/sinsoku/tachikoma_ai)
[![codecov.io](https://codecov.io/github/sinsoku/tachikoma_ai/coverage.svg?branch=master)](https://codecov.io/github/sinsoku/tachikoma_ai?branch=master)

TachikomaAi is a artificial intelligence for [sanemat/tachikoma](https://github.com/sanemat/tachikoma).

## Features

- Append comparing urls to Pull Request

![](https://raw.github.com/sinsoku/tachikoma_ai/master/screenshots/pullreq.png)

## Supported versions

- Ruby 2.0, 2.1.x, 2.2.x, 2.3.x

## Supported strategies

- Bundler (Ruby)

## Installation

Add this line to Gemfile:

```ruby
gem 'tachikoma_ai'
```

And then execute:

    $ bundle

Load a TachikomaAi in `Rakefile`:

```diff
  require 'bundler/setup'
  require 'tachikoma/tasks'
+ require 'tachikoma_ai'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinsoku/tachikoma_ai. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

