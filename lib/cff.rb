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

require 'date'
require 'json'
require 'yaml'

require 'json_schema'
require 'language_list'
require 'spdx-licenses'

require 'cff/version'
require 'cff/util'
require 'cff/model_part'
require 'cff/person'
require 'cff/entity'
require 'cff/reference'
require 'cff/model'
require 'cff/file'
require 'cff/formatter/formatter'
require 'cff/formatter/apa_formatter'
require 'cff/formatter/bibtex_formatter'

# This library provides a Ruby interface to manipulate CITATION.cff files. The
# primary entry points are Model and File.
#
# See the [CITATION.cff documentation](https://citation-file-format.github.io/)
# for more details.
module CFF
  SCHEMA_PATH = ::File.join(__dir__, 'schema', '1.2.0.json') # :nodoc:
  SCHEMA_FILE = JSON.parse(::File.read(SCHEMA_PATH))         # :nodoc:
  SCHEMA = JsonSchema.parse!(SCHEMA_FILE)                    # :nodoc:
end
