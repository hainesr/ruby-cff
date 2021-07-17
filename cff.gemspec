# frozen_string_literal: true

# Copyright (c) 2018-2021 The Ruby Citation File Format Developers.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'lib/cff/version'

Gem::Specification.new do |spec|
  spec.name          = 'cff'
  spec.version       = CFF::VERSION
  spec.authors       = ['Robert Haines']
  spec.email         = ['robert.haines@manchester.ac.uk']

  spec.summary       = 'A Ruby library for manipulating CITATION.cff files.'
  spec.description   = 'See https://citation-file-format.github.io/ ' \
                       'for more info.'
  spec.homepage      = 'https://github.com/citation-file-format/ruby-cff'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^((test|spec|features)/|\.)})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_runtime_dependency 'json_schema', '~> 0.21.0'
  spec.add_runtime_dependency 'language_list', '~> 1.2'
  spec.add_runtime_dependency 'spdx-licenses', '~> 1.3'

  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rdoc', '~> 6.3'
  spec.add_development_dependency 'rubocop', '~> 1.15'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.13'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.0'
  spec.add_development_dependency 'simplecov', '~> 0.20.0'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8.0'
  spec.add_development_dependency 'test_construct', '~> 2.0'
end
