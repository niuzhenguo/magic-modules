<% if false # the license inside this if block assertains to this file -%>
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
<% end -%>
<% res_name = 'sql-test-#{ENV[\'sql_instance_suffix\']}' -%>
<% if name != 'README.md' -%>
<%= compile 'templates/license.erb' -%>

<%= lines(autogen_notice :chef) -%>

<%= compile 'templates/chef/example~auth.rb.erb' -%>

raise ['For this example to run you need to define a env. variable named',
       '"sql_instance_suffix". Please refer to the documentation inside',
       'the example file "<%= name -%>"'].join(' ') \
  unless ENV.key?('sql_instance_suffix')

gsql_instance <%= example_resource_name(res_name) -%> do
  action :create
  project 'google.com:graphite-playground'
  credential 'mycred'
end

<% else -%>
# Tip: Remember to define gsql_instance to match the 'instance' property.
<% end -%>
gsql_user 'john.doe' do
  action :create
  password 'secret-password'
  host '10.1.2.3'
  instance <%= example_resource_name(res_name) %>
  project 'google.com:graphite-playground'
  credential 'mycred'
end
