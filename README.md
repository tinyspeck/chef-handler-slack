# Chef::Handler::SlackReporting

Distribute this Ruby class via a Chef `file` resource and activate it with a Chef resource to this effect:

```ruby
chef_handler 'Chef::Handler::SlackReporting' do
  action :nothing
  arguments [
    channel_id: channel_id,
    token: token,
    workspace_id: workspace_id,
  ]
  source '/usr/local/lib/chef-handler-slack.rb'
end.run_action(:enable)
```

This sample code is provided as-is for the benefit of the community that uses both Chef and Slack.  Since Slack made this code available we've evolved the code considerably but in ways that don't make sense to incorporate into an open-source offering.  Nonetheless, this basic starting point still applies so take it and run with it.
