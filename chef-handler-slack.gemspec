$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = "chef-handler-slack"
  s.version       = "0.1.0"
  s.authors       = ["Derek Smith"]
  s.email         = ["derek@slack-corp.com"]
  s.homepage      = "https://github.com/tinyspeck/chef-handler-slack"
  s.summary       = %q{Chef reports generated to a channel in Slack}
  s.description   = %q{Chef reports generated to a channel in Slack}
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "chef"
end
