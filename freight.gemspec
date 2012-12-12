Gem::Specification.new do |s|
  s.name        = 'freight'
  s.version     = '0.0.0'
  s.date        = '2012-12-10'
  s.summary     = "A Ruby based ESB-like integration bus, inspired by the Enterprise Integration Patterns book"
  s.description = "A Ruby based ESB-like integration bus, inspired by the Enterprise Integration Patterns book by Gregor Hohpe and Bobby Woolf.  Kind of like Apache Camel, except less enterprisey"
  s.authors     = ["Tim Cull"]
  s.email       = 'trcull@pollen.io'
  s.files       = ["lib/freight.rb"]
  s.homepage    = 'http://rubygems.org/gems/freight'
  
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.11'
  
  s.license = 'MIT'
  
   s.bindir      = 'bin'  
end