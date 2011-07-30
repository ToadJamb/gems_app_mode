root_path = File.join(File.dirname(File.expand_path(__FILE__)), '..')
root_path = File.expand_path(root_path)

Bundler.require :test

require 'test/unit'

require_relative '../lib/mode'

file_list = Dir[File.join(root_path, 'test', 'lib', '*.rb')]
file_list.each do |file|
  require file
end
