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

class CFFModelTest < Minitest::Test

  include ::CFF::Util

  def test_bad_methods_not_allowed
    m = ::CFF::Model.new('')

    refute_respond_to(m, :aaaaaaa)
    assert_raises(NoMethodError) do
      m.aaaaaaa
    end

    refute_respond_to(m, :Message)
    assert_raises(NoMethodError) do
      m.Message
    end
  end

  def test_default_model_cff_version
    assert_equal(::CFF::DEFAULT_SPEC_VERSION, ::CFF::Model.new('').cff_version)
  end

  def test_cff_version_is_output_correctly
    m = ::CFF::Model.new('').to_yaml
    assert_includes(m, 'cff-version')
    refute_includes(m, 'cff_version')
  end

  def test_message_is_output_correctly
    ['', 'aaabbbccc'].each do |title|
      m = ::CFF::Model.new(title).to_yaml
      assert_includes(m, "message: #{::CFF::Model::DEFAULT_MESSAGE}")
    end
  end

  def test_set_message
    m = ::CFF::Model.new('title')
    m.message = nil
    y = m.to_yaml
    assert_includes(y, "message: ''")

    m.message = 'this is a message'
    y = m.to_yaml
    assert_equal('this is a message', m.message)
    assert_includes(y, 'message: this is a message')
  end

  def test_title_is_output_correctly
    ['', 'aaabbbccc'].each do |title|
      m = ::CFF::Model.new(title).to_yaml
      assert_includes(m, "title: #{title}")
    end
  end

  def test_set_title
    title = 'software title'
    m = ::CFF::Model.new(title)
    assert_equal(title, m.title)

    title = 'new title'
    m.title = title
    y = m.to_yaml
    assert_equal(title, m.title)
    assert_includes(y, "title: #{title}")
  end

  def test_version_is_set_and_output_correctly
    m = ::CFF::Model.new('title')
    [1.0, '1.0.0'].each do |version|
      m.version = version
      assert_equal(version, m.version)

      y = m.to_yaml
      assert_includes(y, "version: #{version}")
    end
  end

  def test_bad_date_released_raises_error
    m = ::CFF::Model.new('title')

    exp = assert_raises(ArgumentError) do
      m.date_released = 'nonsense'
    end
    assert_includes(exp.message, 'invalid date')
  end

  def test_date_released_is_set_and_output_correctly
    m = ::CFF::Model.new('title')

    date = Date.today
    m.date_released = date
    assert_equal(date, m.date_released)
    y = m.to_yaml
    assert_includes(y, "date-released: #{date.iso8601}")

    date = '1999-12-31'
    m.date_released = date
    assert_equal(Date.parse(date), m.date_released)
    y = m.to_yaml
    assert_includes(y, "date-released: #{date}")
  end

  def test_authors_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    r = [::CFF::Person.new('F', 'S'), '_ _ _', ::CFF::Entity.new('Co.')]

    m.authors << a
    m.authors << '_ _ _'
    m.authors << e

    y = m.to_yaml
    assert_equal(2, m.authors.length)
    assert_includes(
      y,
      "authors:\n- family-names: Second\n  given-names: First\n- name: Company"
    )
    refute_includes(y, '_ _ _')

    m.authors = r

    y = m.to_yaml
    assert_equal(2, m.authors.length)
    assert_includes(
      y, "authors:\n- family-names: S\n  given-names: F\n- name: Co."
    )
    refute_includes(y, '_ _ _')
  end

  def test_simple_fields_set_and_output_correctly
    m = ::CFF::Model.new('title')

    data = [
      ['abstract', 'An abstract'],
      ['commit', 'dce4a2de56c589b55c13249c49a81924ead238b9'],
      ['doi', '10.5281/zenodo.1003150'],
      ['license', 'Apache-2.0'],
      ['license_url', 'http://example.org/licence.txt'],
      ['repository', 'http://example.org/repo/cff'],
      ['repository_artifact', 'http://example.org/repo/cff/package'],
      ['repository_code', 'http://example.org/repo/cff/code'],
      ['url', 'http://userid:password@example.com:8080/']
    ]

    data.each do |method, value|
      assert_equal('', m.send(method))
      m.send("#{method}=", value)
      assert_equal(value, m.send(method))
    end

    y = m.to_yaml

    data.each do |method, value|
      assert_includes(y, "#{method_to_field(method)}: #{value}\n")
    end
  end

  def test_contact_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    r = [::CFF::Person.new('F', 'S'), '_ _ _', ::CFF::Entity.new('Co.')]

    m.contact << a
    m.contact << '_ _ _'
    m.contact << e

    y = m.to_yaml
    assert_equal(2, m.contact.length)
    assert_includes(
      y,
      "contact:\n- family-names: Second\n  given-names: First\n- name: Company"
    )
    refute_includes(y, '_ _ _')

    m.contact = r

    y = m.to_yaml
    assert_equal(2, m.contact.length)
    assert_includes(
      y, "contact:\n- family-names: S\n  given-names: F\n- name: Co."
    )
    refute_includes(y, '_ _ _')
  end

  def test_keywords_set_and_output_correctly
    m = ::CFF::Model.new('title')
    keys = ['one', :two, 3]

    y = m.to_yaml
    refute_includes(y, 'keywords:')

    m.keywords = keys
    l = keys.length
    assert_equal(l, m.keywords.length)

    m.keywords << 'four'
    l += 1
    assert_equal(l, m.keywords.length)

    y = m.to_yaml
    assert_equal(l, m.keywords.length)
    assert_includes(y, "keywords:\n- one\n- two\n- '3'\n- four\n")
  end

  def test_references_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    r = ::CFF::Reference.new('book title', 'book')
    r.authors << a
    r.authors << '_ _ _'
    r.authors << e

    m.references << r
    m.references << '_ _ _'
    assert_equal(2, m.references.length)
    assert_equal(3, m.references[0].authors.length)

    y = m.to_yaml
    assert_equal(1, m.references.length)
    assert_equal(2, m.references[0].authors.length)
    assert_includes(y, "references:\n- type: book\n  title: book title\n")
    assert_includes(
      y,
      "  authors:\n  - family-names: Second\n    given-names: First\n  - name: Company\n"
    )
    refute_includes(y, '_ _ _')
  end

  def test_empty_collections_are_not_output
    m = ::CFF::Model.new('title')
    y = m.to_yaml

    refute_includes(y, 'authors:')
    refute_includes(y, 'contact:')
    refute_includes(y, 'keywords:')
    refute_includes(y, 'references:')
  end

  def test_new_with_block
    model = ::CFF::Model.new('title') do |cff|
      assert_equal('title', cff.title)
      cff.version = '2.0.0'
    end

    assert_equal('title', model.title)
    assert_equal('2.0.0', model.version)
    assert model.is_a?(::CFF::Model)
  end
end
