# -*- encoding: utf-8 -*-
require File.expand_path('../lib/core/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'core'
  spec.version       = Core::VERSION
  spec.summary       = 'TODO: Write a short summary. Required.'
  spec.description   = 'TODO: Write a longer description. Optional.'
  spec.homepage      = 'https://github.va.opower.it/your-GH-name-here/core'

  spec.authors       = ['jcrimmins']
  spec.email         = ['your-email-here@opower.com']

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
  spec.add_development_dependency('rspec', ' 2.14.1')
  spec.add_development_dependency('test_support', ' 0.0.2')
  spec.add_development_dependency('rspec-extra-formatters', ' 0.4')
  spec.add_development_dependency('rubocop', ' 0.24.0')
  spec.add_development_dependency('fuubar', ' 1.3.2')
  spec.add_development_dependency('opower-deployment')
  spec.add_development_dependency('orb_logger', ' 0.0.1')
  spec.add_development_dependency('simplecov', ' 0.7.1')
  # spec.add_runtime_dependency('orb_configuration')
end