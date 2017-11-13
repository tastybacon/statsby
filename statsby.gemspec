Gem::Specification.new do |s|
  s.name        = 'statsby'
  s.version     = '0.0.1'
  s.date        = '2017-11-02'
  s.summary     = 'StatsD Ruby Client'
  s.description = 'A toy implementation of a StatsD client in Ruby'
  s.authors     = ['tastybacon']
  s.email       = 'tastycuredpork@gmail.com'
  s.files       = %w[
    lib/statsby.rb
    lib/statsby/client.rb
    lib/statsby/context.rb
    lib/statsby/tag_set.rb
  ]
  s.homepage    = 'https://github.com/tastybacon/statsby'
  s.license     = 'MIT'

  s.add_development_dependency 'pry', '~>0.11'
  s.add_development_dependency 'rspec', '~>3.0'
  s.add_development_dependency 'rubocop', '~>0.50'
end
