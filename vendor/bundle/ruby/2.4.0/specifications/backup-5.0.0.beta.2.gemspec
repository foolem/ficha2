# -*- encoding: utf-8 -*-
# stub: backup 5.0.0.beta.2 ruby lib

Gem::Specification.new do |s|
  s.name = "backup".freeze
  s.version = "5.0.0.beta.2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael van Rooijen".freeze]
  s.date = "2017-08-27"
  s.description = "Backup is a RubyGem, written for UNIX-like operating systems, that allows you to easily perform backup operations on both your remote and local environments. It provides you with an elegant DSL in Ruby for modeling your backups. Backup has built-in support for various databases, storage protocols/services, syncers, compressors, encryptors and notifiers which you can mix and match. It was built with modularity, extensibility and simplicity in mind.".freeze
  s.email = "meskyanichi@gmail.com".freeze
  s.executables = ["backup".freeze]
  s.files = ["bin/backup".freeze]
  s.homepage = "https://github.com/backup/backup".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Provides an elegant DSL in Ruby for performing backups on UNIX-like systems.".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>.freeze, [">= 0.18.1", "~> 0.18"])
      s.add_runtime_dependency(%q<open4>.freeze, ["= 1.3.0"])
      s.add_runtime_dependency(%q<fog>.freeze, ["~> 1.28"])
      s.add_runtime_dependency(%q<excon>.freeze, ["~> 0.44"])
      s.add_runtime_dependency(%q<unf>.freeze, ["= 0.1.3"])
      s.add_runtime_dependency(%q<dropbox-sdk>.freeze, ["= 1.6.5"])
      s.add_runtime_dependency(%q<net-ssh>.freeze, ["= 3.2.0"])
      s.add_runtime_dependency(%q<net-scp>.freeze, ["= 1.2.1"])
      s.add_runtime_dependency(%q<net-sftp>.freeze, ["= 2.1.2"])
      s.add_runtime_dependency(%q<mail>.freeze, [">= 2.6.6", "~> 2.6"])
      s.add_runtime_dependency(%q<pagerduty>.freeze, ["= 2.0.0"])
      s.add_runtime_dependency(%q<twitter>.freeze, ["~> 5.5"])
      s.add_runtime_dependency(%q<hipchat>.freeze, ["= 1.0.1"])
      s.add_runtime_dependency(%q<flowdock>.freeze, ["= 0.4.0"])
      s.add_runtime_dependency(%q<dogapi>.freeze, ["= 1.11.0"])
      s.add_runtime_dependency(%q<aws-sdk>.freeze, ["~> 2"])
      s.add_runtime_dependency(%q<qiniu>.freeze, ["~> 6.5"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 1.7.2", "~> 1.7"])
      s.add_development_dependency(%q<rubocop>.freeze, ["= 0.48.1"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["= 3.5.0"])
      s.add_development_dependency(%q<mocha>.freeze, ["= 0.14.0"])
      s.add_development_dependency(%q<timecop>.freeze, ["= 0.7.1"])
    else
      s.add_dependency(%q<thor>.freeze, [">= 0.18.1", "~> 0.18"])
      s.add_dependency(%q<open4>.freeze, ["= 1.3.0"])
      s.add_dependency(%q<fog>.freeze, ["~> 1.28"])
      s.add_dependency(%q<excon>.freeze, ["~> 0.44"])
      s.add_dependency(%q<unf>.freeze, ["= 0.1.3"])
      s.add_dependency(%q<dropbox-sdk>.freeze, ["= 1.6.5"])
      s.add_dependency(%q<net-ssh>.freeze, ["= 3.2.0"])
      s.add_dependency(%q<net-scp>.freeze, ["= 1.2.1"])
      s.add_dependency(%q<net-sftp>.freeze, ["= 2.1.2"])
      s.add_dependency(%q<mail>.freeze, [">= 2.6.6", "~> 2.6"])
      s.add_dependency(%q<pagerduty>.freeze, ["= 2.0.0"])
      s.add_dependency(%q<twitter>.freeze, ["~> 5.5"])
      s.add_dependency(%q<hipchat>.freeze, ["= 1.0.1"])
      s.add_dependency(%q<flowdock>.freeze, ["= 0.4.0"])
      s.add_dependency(%q<dogapi>.freeze, ["= 1.11.0"])
      s.add_dependency(%q<aws-sdk>.freeze, ["~> 2"])
      s.add_dependency(%q<qiniu>.freeze, ["~> 6.5"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.7.2", "~> 1.7"])
      s.add_dependency(%q<rubocop>.freeze, ["= 0.48.1"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["= 3.5.0"])
      s.add_dependency(%q<mocha>.freeze, ["= 0.14.0"])
      s.add_dependency(%q<timecop>.freeze, ["= 0.7.1"])
    end
  else
    s.add_dependency(%q<thor>.freeze, [">= 0.18.1", "~> 0.18"])
    s.add_dependency(%q<open4>.freeze, ["= 1.3.0"])
    s.add_dependency(%q<fog>.freeze, ["~> 1.28"])
    s.add_dependency(%q<excon>.freeze, ["~> 0.44"])
    s.add_dependency(%q<unf>.freeze, ["= 0.1.3"])
    s.add_dependency(%q<dropbox-sdk>.freeze, ["= 1.6.5"])
    s.add_dependency(%q<net-ssh>.freeze, ["= 3.2.0"])
    s.add_dependency(%q<net-scp>.freeze, ["= 1.2.1"])
    s.add_dependency(%q<net-sftp>.freeze, ["= 2.1.2"])
    s.add_dependency(%q<mail>.freeze, [">= 2.6.6", "~> 2.6"])
    s.add_dependency(%q<pagerduty>.freeze, ["= 2.0.0"])
    s.add_dependency(%q<twitter>.freeze, ["~> 5.5"])
    s.add_dependency(%q<hipchat>.freeze, ["= 1.0.1"])
    s.add_dependency(%q<flowdock>.freeze, ["= 0.4.0"])
    s.add_dependency(%q<dogapi>.freeze, ["= 1.11.0"])
    s.add_dependency(%q<aws-sdk>.freeze, ["~> 2"])
    s.add_dependency(%q<qiniu>.freeze, ["~> 6.5"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.7.2", "~> 1.7"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.48.1"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["= 3.5.0"])
    s.add_dependency(%q<mocha>.freeze, ["= 0.14.0"])
    s.add_dependency(%q<timecop>.freeze, ["= 0.7.1"])
  end
end
