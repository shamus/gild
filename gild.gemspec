# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gild/version"

Gem::Specification.new do |s|
  s.name        = "gild"
  s.version     = Gild::VERSION
  s.authors     = ["Jeremy Morony"]
  s.email       = ["jeremy@sidereel.com"]
  s.homepage    = "https://github.com/jeremysmears/gild"
  s.summary     = %q{A JSON templating library.}
  s.description = %q{A JSON templating library, inspired by Gild but with a syntax that favors blocks.}

  s.rubyforge_project = "gild"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency 'multi_json', '~> 1.0.3'
end
