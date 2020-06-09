Gem::Specification.new do |s|
  s.name     = 'delegates'
  s.version  = '0.0.1'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/delegates'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/zverok/delegates/issues',
    'documentation_uri' => 'https://www.rubydoc.info/gems/delegates/',
    'homepage_uri' => 'https://github.com/zverok/delegates',
    'source_code_uri' => 'https://github.com/zverok/delegates'
  }

  s.summary = 'delegate :methods, to: :target, extracted from ActiveSupport'
  s.description = <<-EOF
    ActiveSupport's delegation syntax is much more convenient than Ruby's stdlib Forwardable.
    This gem just extracts it as an independent functionality (available on-demand without
    monkey-patching Module).
  EOF
  s.licenses = ['MIT']

  s.required_ruby_version = '>= 2.4.0'

  s.files = `git ls-files lib LICENSE.txt *.md`.split($RS)
  s.require_paths = ["lib"]

  s.add_development_dependency 'rubocop', '~> 0.85.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.38.0'

  s.add_development_dependency 'rspec', '>= 3.8'
  s.add_development_dependency 'rspec-its', '~> 1'
  s.add_development_dependency 'saharspec', '>= 0.0.7'
  s.add_development_dependency 'simplecov', '~> 0.9'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubygems-tasks'

  s.add_development_dependency 'yard'
end
