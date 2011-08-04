################################################################################
namespace :gem do
################################################################################

  gem_name = File.basename(File.expand_path(File.join(__FILE__, '..', '..')))
  version = nil
  File.open("#{gem_name}.gemspec", 'r') do |file|
    while line = file.gets
      if line =~ /version *=/
        version = line.sub(/.*=/, '').strip[1..-2]
        break
      end
    end
  end
  gem_file = "#{gem_name}-#{version}.gem"

  file gem_file => ["#{gem_name}.gemspec", *Dir['lib/**/*.rb']] do |t|
    output = `gem build #{gem_name}.gemspec`
    puts output
  end

  desc "Build #{gem_name} gem version #{version}."
  task :build => gem_file

  desc "Install the #{gem_name} gem."
  task :install => [gem_file] do |t|
    puts `gem install #{gem_file} --no-rdoc --no-ri`
  end

  desc "Removes files associated with building and installing #{gem_name}."
  task :clobber do |t|
    FileUtils.rm_f gem_file
  end

  desc "Removes the gem file, builds, and installs."
  task :generate => ['gem:clobber', gem_file, 'gem:install']

################################################################################
end # :gem
################################################################################

task :clobber => 'gem:clobber'
