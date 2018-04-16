# -*- encoding: utf-8 -*-
# stub: pagerduty 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pagerduty".freeze
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Charlie Somerville".freeze, "Orien Madgwick".freeze]
  s.date = "2014-05-26"
  s.description = "Provides a lightweight interface for calling the PagerDuty Integration API".freeze
  s.email = ["charlie@charliesomerville.com".freeze, "_@orien.io".freeze]
  s.homepage = "http://github.com/envato/pagerduty".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "If upgrading to pagerduty 2.0.0 please note the API changes:\nhttps://github.com/envato/pagerduty#upgrading-to-version-200\n".freeze
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Pagerduty Integration API client library".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>.freeze, [">= 1.7.7"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-given>.freeze, [">= 0"])
    else
      s.add_dependency(%q<json>.freeze, [">= 1.7.7"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-given>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<json>.freeze, [">= 1.7.7"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-given>.freeze, [">= 0"])
  end
end
