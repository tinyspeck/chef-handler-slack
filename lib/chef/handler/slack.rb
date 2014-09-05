#
# Author:: Derek Smith <derek@slack-corp.com>
# Copyright:: Copyright (c) 2014, Derek Smith
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "rubygems"
Gem.clear_paths
require "chef"
require "chef/handler"

require "net/http"
require "uri"
require "json"

class SlackReporting < Chef::Handler::Slack
  attr_accessor :source, :team, :icon_emoj, :channel, :token, :username

  def initialize(options = {})
    @source = options[:source] || "#{Chef::Config[:node_name]}"
    @channel = options[:channel] || "#test"
    @api_key = options[:token] || "token"
    @team = options[:team] || "doesnotexist"
    @username = options[:username] || "chef"
  end

  def report
    gemspec = if Gem::Specification.respond_to? :find_by_name
                Gem::Specification.find_by_name('chef-handler-slack')
              else
                Gem.source_index.find_name('chef-handler-slack').last
              end

    Chef::Log.debug("#{gemspec.full_name} loaded as a handler.")

    params = {
      :username => @username,
      :icon_emoji => @icon_emoj,
      :channel => @channel,
      :text => "HELLO",
    }

    begin
      http = Net::HTTP.new
      uri = URI.parse("https://#{@team}.slack.com/services/hooks/incoming-webhook?token=#{@token}")
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(params)
      http.request(req)
    rescue Exception => e
      puts "#{e}"
    end
  end
end
