# Hcheck

Configuration driven health checker for ruby apps. Can be mounted or booted as standalone app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hcheck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hcheck

## Usage

To run as standalone server:
``` bash
  hcheck -c path/to/hcheck.yml
  hcheck # looks for hcheck.yml in current project root path
```

Usage in rails:
``` ruby
  # routes.rb
  mount Hcheck::Status => '/hcheck' # Needs hcheck.yml in config directory.
```

Example `hcheck.yml`
``` yaml
postgresql:
  check: App Main Store # Name of the check
  host: localhost
  port: 5432
  username: root
  password:
  database: postgres

```
A complex `hcheck.yml`
``` yaml
postgresql:
  check: App Main Store
  host: <%= ENV['PG_HOST'] %>
  port: 5432
  username: <%= `whoami` %>
  password: <%= ENV['PG_PASSWORD'] %>
  database: <%= ENV['PG_DBNAME'] %>
redis:
  - check: App Main Cache
    url: redis://localhost:6379
    db: hcheck
    password:
  - check: Delayed Jobs Store
    url: redis://mymaster
    db: hcheck
    password:
    role: master
    sentinels:
      - host: localhost
        port: 26379
      - host: localhost
        port: 26380
mongodb:
  check: Mongo DB
  hosts:
    - localhost:27017
  user:
  password:
mysql:
  check: Mysql Connection
  host: localhost
  username: localuser
  password: password
rabbitmq:
  check: Rabbit Main
  host: localhost
  port: 5672
  user: guest
  pass: guest
ping:
  check: Main App Home
  url: http://127.0.0.1:3033/
```

`check` key refers to name or description than can be given to a check.

There is also a generator available if you fancy it: `hcheck g:config`, generates a sample hcheck yaml config file for you.

## Authenticated Hcheck

Basic token based authentication can be enabled if desired. Env variable `HCHECK_SECURE` can set set to protect the hcheck path and `HCHECK_ACCESS_TOKEN`can be used to set token. Token can then sent as `token` get params, like `/hcheck?token=xxx`. Authentication failure will render 401.

## Dependencies

The checks are implemented with the help of available gems. Postgresql check require `pg` gem, redis requires `redis` and so on. Check out individual module files in `lib/hcheck/checks` to see what and how they are being required.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `rubocop` to smash all silly errors and style deficiencies.

The checks during test loads the environmental settings from `spec/.env` for helping with testing in local machine.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Todo

Travis CI Integrations
  - Github PR status
  - Continuous Integration
  - Continuous release to RubyGems

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rohitrox/hcheck.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
