gem_spec = Gem::Specification.new do |s|
  s.name = 'mode'
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

  s.add_development_dependency 'Platform',      '~> 0.4.0'
  s.add_development_dependency 'highline',      '~> 1.6.1'
  s.add_development_dependency 'execute_shell', '~> 0.0.1'

  s.has_rdoc = true
end
