# Copyright (c) 2018 Robert Haines.
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

#
module CFF

  # Model is the core data structure for a CITATION.cff file. It can be
  # accessed direcly, or via File.
  class Model

    include Util

    ALLOWED_FIELDS = [
      'abstract',
      'cff-version',
      'commit',
      'date-released',
      'doi',
      'message',
      'title',
      'version'
  ].freeze # :nodoc:

    # The default message to use if none is explicitly set.
    DEFAULT_MESSAGE = "If you use this software in your work, please cite it using the following metadata"

    # :call-seq:
    #   new(title) -> Model
    #
    # Initialize a new Model with the supplied title.
    def initialize(param)
      @authors = []
      @contact = []
      @keywords = []

      if Hash === param
        build_model(param)
      else
        @fields = Hash.new('')
        @fields['cff-version'] = DEFAULT_SPEC_VERSION
        @fields['message'] = DEFAULT_MESSAGE
        @fields['title'] = param
      end
    end

    # :call-seq:
    #   authors -> Array
    #
    # Return the list of authors for this citation. To add an author to the
    # list, use:
    #
    # ```
    # model.authors << author
    # ```
    #
    # Authors can be a Person or Entity.
    def authors
      @authors
    end

    # :call-seq:
    #   contact -> Array
    #
    # Return the list of contacts for this citation. To add a contact to the
    # list, use:
    #
    # ```
    # model.contact << contact
    # ```
    #
    # Contacts can be a Person or Entity.
    def contact
      @contact
    end

    # :call-seq:
    #   date_released = date
    #
    # Set the `date-released` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_released=(date)
      unless Date === date
        date = Date.parse(date)
      end

      @fields['date-released'] = date
    end

    # :call-seq:
    #   keywords -> Array
    #
    # Return the list of keywords for this citation. To add a keyword to the
    # list, use:
    #
    # ```
    # model.keywords << keyword
    # ```
    #
    # Keywords will be converted to Strings on output to a CFF file.
    def keywords
      @keywords
    end

    # :call-seq:
    #   version = version
    #
    # Set the `version` field.
    def version=(version)
      @fields['version'] = version.to_s
    end

    def to_yaml # :nodoc:
      fields = @fields.dup
      fields['authors'] = array_field_to_yaml(@authors) unless @authors.empty?
      fields['contact'] = array_field_to_yaml(@contact) unless @contact.empty?
      fields['keywords'] = @keywords.map { |k| k.to_s } unless @keywords.empty?

      YAML.dump fields, :line_width => -1, :indentation => 2
    end

    def method_missing(name, *args) # :nodoc:
      n = method_to_field(name.id2name)
      super unless ALLOWED_FIELDS.include?(n.chomp('='))

      if n.end_with?('=')
        @fields[n.chomp('=')] = args[0] || ''
      else
        @fields[n]
      end
    end

    private

    def build_model(fields)
      build_entity_collection(@authors, fields['authors'])
      build_entity_collection(@contact, fields['contact'])
      build_string_collection(@keywords, fields['keywords'])

      @fields = delete_from_hash(fields, 'authors', 'contact', 'keywords')
    end

    def build_entity_collection(field, source)
      source.each do |s|
        field << (s.has_key?('given-names') ? Person.new(s) : Entity.new(s))
      end
    end

    def build_string_collection(field, source)
      source.each do |s|
        field << s
      end
    end

    def array_field_to_yaml(field)
      field.reject do |f|
        !f.respond_to?(:fields)
      end.map { |f| f.fields }
    end

  end
end
