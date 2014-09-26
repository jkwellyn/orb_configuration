# -*- encoding: utf-8 -*-
require File.expand_path('../lib/orb_configuration/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'orb_configuration'
  spec.version       = OrbConfiguration::VERSION
  spec.summary       = 'A simple configuration library.'
  spec.description   = 'Provides programatic access to config/config.yml'
  spec.homepage      = 'https://github.va.opower.it/auto/orb_configuration'

  spec.authors       = ['jcrimmins']
  spec.email         = ['john.crimmins@opower.com']

  # This gem will work with 1.9.3 or greater...
  spec.required_ruby_version = '>= 1.9.3'

  spec.license       = 'MIT'

  # file attributes...
  spec.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency('rake', '~> 10.1.1')
  spec.add_development_dependency('annotation_manager', '~> 0.0.2')
  spec.add_development_dependency('yard', '~> 0.8.7')
  spec.add_development_dependency('redcarpet', '~> 2.3.0')
  spec.add_development_dependency('rspec', '~> 3.1')
  spec.add_development_dependency('rspec-legacy_formatters', '~> 1.0')
  spec.add_development_dependency('rspec-extra-formatters', '~> 1.0')
  spec.add_development_dependency('rubocop', ' 0.24.0')
  spec.add_development_dependency('fuubar', '~> 2.0')
  spec.add_development_dependency('opower-deployment')
  spec.add_development_dependency('simplecov', ' 0.7.1')
  spec.add_runtime_dependency('recursive-open-struct')
  spec.add_runtime_dependency('orb_logger')
  spec.add_runtime_dependency('activesupport', '>= 3.0.0')
end
