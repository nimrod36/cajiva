# -*- encoding: utf-8 -*-
# stub: middleware 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "middleware".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mitchell Hashimoto".freeze]
  s.date = "2012-03-16"
  s.description = "Generalized implementation of the middleware abstraction for Ruby.".freeze
  s.email = ["mitchell.hashimoto@gmail.com".freeze]
  s.homepage = "https://github.com/mitchellh/middleware".freeze
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Generalized implementation of the middleware abstraction for Ruby.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<redcarpet>.freeze, ["~> 2.1.0"])
  s.add_development_dependency(%q<rspec-core>.freeze, ["~> 2.8.0"])
  s.add_development_dependency(%q<rspec-expectations>.freeze, ["~> 2.8.0"])
  s.add_development_dependency(%q<rspec-mocks>.freeze, ["~> 2.8.0"])
  s.add_development_dependency(%q<yard>.freeze, ["~> 0.7.5"])
end
