# -*- encoding: utf-8 -*-
# stub: twitter-bootstrap-rails 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "twitter-bootstrap-rails".freeze
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Seyhun Akyurek".freeze]
  s.date = "2017-02-06"
  s.description = "twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 4, 3.x Asset Pipeline".freeze
  s.email = ["seyhunak@gmail.com".freeze]
  s.homepage = "https://github.com/seyhunak/twitter-bootstrap-rails".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "Important: You may need to add a javascript runtime to your Gemfile in order for bootstrap's LESS files to compile to CSS. \n\n**********************************************\n\nExecJS supports these runtimes:\n\ntherubyracer - Google V8 embedded within Ruby\n\ntherubyrhino - Mozilla Rhino embedded within JRuby\n\nNode.js\n\nApple JavaScriptCore - Included with Mac OS X\n\nMicrosoft Windows Script Host (JScript)\n\n**********************************************\n".freeze
  s.rubyforge_project = "twitter-bootstrap-rails".freeze
  s.rubygems_version = "2.6.14".freeze
  s.summary = "Bootstrap CSS toolkit for Rails 4, 3.x Asset Pipeline".freeze

  s.installed_by_version = "2.6.14" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>.freeze, [">= 5.0.1", "~> 5.0"])
      s.add_runtime_dependency(%q<actionpack>.freeze, [">= 5.0.1", "~> 5.0"])
      s.add_runtime_dependency(%q<less-rails>.freeze, [">= 2.8.0", "~> 2.8"])
      s.add_runtime_dependency(%q<execjs>.freeze, ["~> 2.7"])
      s.add_development_dependency(%q<rails>.freeze, [">= 5.0.1", "~> 5.0"])
      s.add_development_dependency(%q<less>.freeze, ["~> 2.6"])
      s.add_development_dependency(%q<therubyracer>.freeze, ["~> 0.12"])
    else
      s.add_dependency(%q<railties>.freeze, [">= 5.0.1", "~> 5.0"])
      s.add_dependency(%q<actionpack>.freeze, [">= 5.0.1", "~> 5.0"])
      s.add_dependency(%q<less-rails>.freeze, [">= 2.8.0", "~> 2.8"])
      s.add_dependency(%q<execjs>.freeze, ["~> 2.7"])
      s.add_dependency(%q<rails>.freeze, [">= 5.0.1", "~> 5.0"])
      s.add_dependency(%q<less>.freeze, ["~> 2.6"])
      s.add_dependency(%q<therubyracer>.freeze, ["~> 0.12"])
    end
  else
    s.add_dependency(%q<railties>.freeze, [">= 5.0.1", "~> 5.0"])
    s.add_dependency(%q<actionpack>.freeze, [">= 5.0.1", "~> 5.0"])
    s.add_dependency(%q<less-rails>.freeze, [">= 2.8.0", "~> 2.8"])
    s.add_dependency(%q<execjs>.freeze, ["~> 2.7"])
    s.add_dependency(%q<rails>.freeze, [">= 5.0.1", "~> 5.0"])
    s.add_dependency(%q<less>.freeze, ["~> 2.6"])
    s.add_dependency(%q<therubyracer>.freeze, ["~> 0.12"])
  end
end
