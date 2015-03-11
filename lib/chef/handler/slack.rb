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

class Chef
  class Handler
    class SlackReporting < Chef::Handler
      attr_accessor :source, :team, :icon_emoj, :channel, :token, :username, :icon_emoj

      def initialize(options = {})
        @source = options[:source] || "#{Chef::Config[:node_name]}"
        @channel = options[:channel] || "#test"
        @token = options[:token] || "token"
        @team = options[:team] || "doesnotexist"
        @username = options[:username] || "chef"
        @icon_emoj = options[:icon_emoj] || ":chef:"
        @send_at_success = options[:send_at_success] || false
      end

      def report
        gemspec = if Gem::Specification.respond_to? :find_by_name
                    Gem::Specification.find_by_name('chef-handler-slack')
                  else
                    Gem.source_index.find_name('chef-handler-slack').last
                  end

        Chef::Log.debug("#{gemspec.full_name} loaded as a handler.")

        if run_status.success?
          msg = "Chef run Success on *#{source}*"
          send(msg) if @send_at_success
        else
          msg = "Chef run failed on *#{source}*"
          if !run_status.exception.nil?
            msg += ":\n```"
            msg += run_status.formatted_exception.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
            msg += '```'
          end

          send(msg)
        end
      end

      def send(msg)
        params = {
          :username => @username,
          :icon_emoji => @icon_emoj,
          :channel => @channel,
          :text => msg,
          :token => @token,
        }

        uri = URI("https://#{@team}.slack.com/services/hooks/incoming-webhook?token=#{@token}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        begin
          req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
          req.set_form_data({:payload => params.to_json})
          http.request(req).body
        rescue Exception => e
          Chef::Log.warn("An unhandled execption occured while posting a message to Slack: #{e}")
        end
      end
    end
  end
end
