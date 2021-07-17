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

require 'test_helper'

class CFFErrorsTest < Minitest::Test

  def test_validation_error
    error = ::CFF::ValidationError.new(['test'])
    assert_equal('Validation error: test', error.message)
  end

  # rubocop:disable Style/RescueStandardError
  def test_rescue_validation_error_as_standard_error
    raise ::CFF::ValidationError.new([])
  rescue
    # Catch.
  end
  # rubocop:enable Style/RescueStandardError
end
