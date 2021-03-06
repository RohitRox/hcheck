# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hcheck/version'

Gem::Specification.new do |spec|
  spec.name          = 'hcheck'
  spec.version       = Hcheck::VERSION
  spec.authors       = ['Rohit Joshi']
  spec.email         = ['link2j.roy@gmail.com']

  spec.summary       = 'Health checker for ruby apps'
  spec.description   = 'Health checker for ruby apps. Can be mounted or booted as standalone app'
  spec.homepage      = ''
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'haml', '~> 5.0'
  spec.add_runtime_dependency 'sinatra', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.16'

  spec.add_development_dependency 'bunny', '~> 2.9.2'
  spec.add_development_dependency 'dalli', '~> 2.7.8'
  spec.add_development_dependency 'mongo', '~> 2.4.3'
  spec.add_development_dependency 'mysql2', '~> 0.5.2'
  spec.add_development_dependency 'pg', '~> 0.18'
  spec.add_development_dependency 'redis', '~> 4.0.2'

  spec.add_development_dependency 'haml', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'sinatra', '~> 2.0'

  spec.add_development_dependency 'dotenv', '~> 2.5.0'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rack-test', '~> 1.1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.58.2'
end
