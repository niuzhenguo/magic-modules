# Copyright 2017 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'api/object'
require 'provider/resource_override'

module Provider
  # A hash of Provider::PropertyOverride objects where the key is the api name for that
  # object.
  #
  # Example usage in a provider.yaml file where you want to extend a resource
  # description:
  #
  # overrides: !ruby/object:Provider::ResourceOverrides
  #   SomeResource: !ruby/object:Provider::MyProvider::ResourceOverride
  #     properties: !ruby/object:Provider::PropertyOverrides
  #       someProperty: !ruby/object:Provider::Terraform::PropertyOverride
  #         description: 'foo'
  #   ...
  class PropertyOverrides < Api::Object
    def consume_api(api)
      @__api = api
    end

    def validate
      return unless @__objects.nil? # allows idempotency of calling validate
      convert_findings_to_hash
      super
    end

    def [](index)
      @__objects[index]
    end

    def each
      return enum_for(:each) unless block_given?
      @__objects.each { |o| yield o }
      self
    end

    def select
      return enum_for(:select) unless block_given?
      @__objects.select { |o| yield o }
      self
    end

    def fetch(key, *args)
      # *args only holds default value. Needs to mimic ::Hash
      if args.empty?
        # KeyErorr will be thrown if key not found
        @__objects&.fetch(key)
      else
        # args[0] will be returned if key not found
        @__objects&.fetch(key, args[0])
      end
    end

    def key?(key)
      @__objects&.key?(key)
    end

    private

    # Converts every variable into @__objects
    def convert_findings_to_hash
      @__objects = {}
      instance_variables.each do |var|
        next if var.id2name.start_with?('@__')
        @__objects[var.id2name[1..-1]] = instance_variable_get(var)
        remove_instance_variable(var)
      end
    end
  end
end
