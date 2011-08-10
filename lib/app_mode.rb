gem_name = File.basename(__FILE__, '.rb')

require_relative File.join(gem_name, 'state_manager')
require_relative File.join(gem_name, gem_name)
