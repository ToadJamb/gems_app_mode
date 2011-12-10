Gem::Specification.new do |s|
  s.name = 'app_mode'
  s.version = '1.0.2'

  s.summary = 'State management for objects and applications.'
  s.description = %Q{
AppMode provides state management for modules, classes, libraries,
and applications. It may even be used to create and manage new states.
The possibilities are endless. This is your chance to create
a :solid state, :contemplative state, or even a :free state.
}.strip

  s.author   = 'Travis Herrick'
  s.email    = 'tthetoad@gmail.com'
  s.homepage = 'http://www.bitbucket.org/ToadJamb/gems_app_mode'

  s.license = 'GPLV3'

  s.extra_rdoc_files << 'README'

  s.require_paths = ['lib']
  s.files = Dir['lib/**/*.rb', '*']
  s.test_files = Dir['test/**/*.rb']

  s.add_development_dependency 'rake_tasks', '~> 2.0.3'

  s.has_rdoc = true
end
