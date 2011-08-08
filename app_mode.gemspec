Gem::Specification.new do |s|
  s.name = 'app_mode'
  s.version = '0.0.2'

  s.summary = 'Application state management.'
  s.description = 'AppMode provides state management for ' +
    'modules, classes, libraries, and applications.'

  s.author   = 'Travis Herrick'
  s.email    = 'tthetoad@gmail.com'
  s.homepage = 'http://www.bitbucket.org/ToadJamb/gems_app_mode'

  s.license = 'GPLV3'

  s.extra_rdoc_files << 'README'

  s.require_paths = ['lib']
  s.files = Dir['lib/**/*.rb', '*']
  s.test_files = Dir['test/**/*.rb']

  s.add_development_dependency 'rake_tasks', '~> 0.0.1'

  s.has_rdoc = true
end
