#--
################################################################################
#                      Copyright (C) 2011 Travis Herrick                       #
################################################################################
#                                                                              #
#                                 \v^V,^!v\^/                                  #
#                                 ~%       %~                                  #
#                                 {  _   _  }                                  #
#                                 (  *   -  )                                  #
#                                 |    /    |                                  #
#                                  \   _,  /                                   #
#                                   \__.__/                                    #
#                                                                              #
################################################################################
# This program is free software: you can redistribute it                       #
# and/or modify it under the terms of the GNU General Public License           #
# as published by the Free Software Foundation,                                #
# either version 3 of the License, or (at your option) any later version.      #
#                                                                              #
# Commercial licensing may be available for a fee under a different license.   #
################################################################################
# This program is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY;                                                    #
# without even the implied warranty of MERCHANTABILITY                         #
# or FITNESS FOR A PARTICULAR PURPOSE.                                         #
# See the GNU General Public License for more details.                         #
#                                                                              #
# You should have received a copy of the GNU General Public License            #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.        #
################################################################################
#++

require_relative 'require'

class AppModeTest < Test::Unit::TestCase
  include StateManagerSupport

  def setup
    @class = AppMode
    @class.setup
    super
  end

  ############################################################################
  # Class tests.
  ############################################################################

  def test_class_default_settings
    assert_equal :production, @class.state
    assert_equal states(:default), @class.valid_states

    assert_false @class.development
    assert_false @class.test
    assert_false @class.rake
    assert_true @class.production
  end

  def test_class_setting_state
    assert_nothing_raised { @class.state = :test }

    assert_equal :test, @class.state
    assert_true @class.test

    assert_nothing_raised { @class.state = :development }

    assert_equal :development, @class.state
    assert_true @class.development
  end

  def test_class_invalid_state
    assert_raise(RuntimeError) { @class.setup :invalid }
    assert_raise(NoMethodError) { @class.invalid }
  end

  def test_class_respond_to
    @class.state = :test

    method_list.each_value do |method|
      assert_respond_to @class, method
    end

    states(:default).each do |method|
      assert_respond_to @class, method
    end

    assert_not_respond_to @class, :invalid
  end

  # This test exists because of Kernel::test.
  def test_class_send_method
    @class.state = :test
    assert_equal :test, @class.send(:state)
    assert_false @class.send(:development)
    assert_true @class.send(:test)
    assert_false @class.send(:rake)
    assert_false @class.send(:production)

    @class.setup :development, [:development, :production]
    assert_equal :development, @class.send(:state)
    assert_true @class.send(:development)
    assert_false @class.send(:production)
    assert_raise(ArgumentError) { @class.send(:test) }
  end

  ############################################################################
  private
  ############################################################################

  ############################################################################
  # Assertions - stolen from test_internals.
  ############################################################################

  # Asserts that a value is equal to false.
  # ==== Input
  # [value : Any] The value to check for equality against false.
  # [message : String : nil] The message to display if the value is not false.
  def assert_false(value, message = nil)
    assert_equal false, value, message
  end

  # Asserts that a value is equal to true.
  # ==== Input
  # [value : Any] The value to check for equality against true.
  # [message : String : nil] The message to display if the value is not true.
  def assert_true(value, message = nil)
    assert_equal true, value, message
  end
end
