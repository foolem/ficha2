# -*- encoding: utf-8 -*-
# stub: dogapi 1.11.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dogapi".freeze
  s.version = "1.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Datadog, Inc.".freeze]
  s.date = "2014-07-07"
  s.description = "Ruby bindings for Datadog's API".freeze
  s.email = ["packages@datadoghq.com".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze]
  s.homepage = "http://datadoghq.com/".freeze
  s.licenses = ["BSD".freeze]
  s.rdoc_options = ["--title".freeze, "DogAPI -- Datadog Client".freeze, "--main".freeze, "README.rdoc".freeze, "--line-numbers".freeze, "--inline-source".freeze]
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Ruby bindings for Datadog's API".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>.freeze, [">= 1.5.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
    else
      s.add_dependency(%q<json>.freeze, [">= 1.5.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_dependency(%q<rake>.freeze, ["~> 10"])
      s.add_dependency(%q<rdoc>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<json>.freeze, [">= 1.5.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rake>.freeze, ["~> 10"])
    s.add_dependency(%q<rdoc>.freeze, [">= 0"])
  end
end
