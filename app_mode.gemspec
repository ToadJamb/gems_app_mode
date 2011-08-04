Gem::Specification.new do |s|
  s.name = 'app_mode'
  s.version = '0.0.1'

  s.summary = 'Indicates what mode ' +
    '(i.e. development, test, etc.) the code is running in.'

  s.author = 'Travis Herrick'
  s.email = 'tthetoad@gmail.com'

  s.license = 'GPLV3'

  s.extra_rdoc_files << 'README'

  s.require_paths = ['lib']
  s.files = Dir['lib/**/*.rb', '*']
  s.test_files = Dir['test/**/*.rb']

  s.add_development_dependency 'rake', '~> 0.8.7'

  s.has_rdoc = true
end
