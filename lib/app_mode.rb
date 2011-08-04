gem_name = File.basename(__FILE__, '.rb')

require_relative File.join(gem_name, gem_name)
