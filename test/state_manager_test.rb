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

class StateManagerTest < Test::Unit::TestCase
  include StateManagerSupport

  def setup
    @class = StateManager
    @obj = nil
    super
  end

  def test_default_settings
    create

    assert_equal :production, @obj.state
    assert_equal states(:default), @obj.valid_states

    assert_true @obj.production
    assert_false @obj.development
    assert_false @obj.test
  end

  def test_setting_state
    create :test

    assert_equal :test, @obj.state
    assert_true @obj.test

    assert_nothing_raised { @obj.state = :development }

    assert_equal :development, @obj.state
    assert_true @obj.development
  end

  def test_new_object
    create :test
    assert_equal :test, @obj.state
    assert_false @obj.development
    assert_true @obj.test
    assert_false @obj.rake
    assert_false @obj.production

    create :development
    assert_equal :development, @obj.state
    assert_true @obj.development
    assert_false @obj.test
    assert_false @obj.rake
    assert_false @obj.production

    create :production
    assert_equal :production, @obj.state
    assert_false @obj.development
    assert_false @obj.test
    assert_false @obj.rake
    assert_true @obj.production

    create :rake
    assert_equal :rake, @obj.state
    assert_false @obj.development
    assert_false @obj.test
    assert_true @obj.rake
    assert_false @obj.production
  end

  def test_dynamic_state
    assert_nothing_raised { create :dynamic }
    assert_false @obj.development
    assert_false @obj.test
    assert_false @obj.rake
    assert_true @obj.production

    assert_nothing_raised { create :dynamic, states(:dev) }
    assert_true @obj.dev_dev
    assert_false @obj.dev_test
    assert_false @obj.dev_rake
    assert_false @obj.dev_prod

    assert_nothing_raised { create :dynamic, states(:test) }
    assert_false @obj.test_dev
    assert_true @obj.test_test
    assert_false @obj.test_rake
    assert_false @obj.test_prod

    assert_nothing_raised { create :dynamic, states(:rake) }
    assert_false @obj.rake_dev
    assert_false @obj.rake_test
    assert_true @obj.rake_rake
    assert_false @obj.rake_prod

    assert_nothing_raised { create :dynamic, states(:prod) }
    assert_false @obj.prod_dev
    assert_false @obj.prod_test
    assert_false @obj.prod_rake
    assert_true @obj.prod_prod

    assert_raise(NoMethodError) { @obj.dynamic }
    assert_raise(NoMethodError) { @obj.test }

    assert_nothing_raised { create :dynamic, states(:test_test_class) }
    assert_false @obj.test_test_class_dev
    assert_true @obj.test_ttc
    assert_false @obj.rake
    assert_false @obj.prod

    assert_nothing_raised { create :dynamic, states(:tests_test_class) }
    assert_false @obj.tests_test_class_dev
    assert_true @obj.test_stc
    assert_false @obj.rake
    assert_false @obj.prod

    assert_nothing_raised { create :dynamic, states(:test_class_test) }
    assert_false @obj.test_class_test_dev
    assert_true @obj.test_tct
    assert_false @obj.rake
    assert_false @obj.prod

    assert_nothing_raised { create :dynamic, states(:tests_class_test) }
    assert_false @obj.tests_class_test_dev
    assert_true @obj.test_sct
    assert_false @obj.rake
    assert_false @obj.prod
  end

  def test_dynamic_state_with_less_than_ideal_number_of_states
    [
      :dev,
      :test,
      :rake,
      :prod,
    ].each do |state|
      state_array = states(state)[0..3]
      end_value = state_array.length - 1

      (0..end_value).each do |i|
        assert_nothing_raised { create :dynamic, states(state)[0..i] }
        case i
          when 0
            assert_true @obj.send("#{state}_dev")
          when 1
            case state
              when :dev
                assert_true @obj.dev_dev
              else
                assert_true @obj.send("#{state}_test")
            end
          when 2
            case state
              when :dev
                assert_true @obj.dev_dev
              when :test
                assert_true @obj.test_test
              else
                assert_true @obj.send("#{state}_rake")
            end
          when 3
            case state
              when :dev
                assert_true @obj.dev_dev
              when :test
                assert_true @obj.test_test
              when :rake
                assert_true @obj.rake_rake
              when :prod
                assert_true @obj.prod_prod
            end
        end
      end
    end
  end

  def test_invalid_state
    assert_raise(RuntimeError) { create :invalid }
    assert_raise(NoMethodError) { create :test; @obj.invalid }
  end

  def test_respond_to
    create :test

    method_list.each_value do |method|
      assert_respond_to @obj, method
    end

    states(:default).each do |method|
      assert_respond_to @obj, method
    end

    assert_not_respond_to @obj, :invalid
  end

  # This test exists because of Kernel::test.
  def test_send_method
    create :test
    assert_equal :test, @obj.send(:state)
    assert_false @obj.send(:development)
    assert_true @obj.send(:test)
    assert_false @obj.send(:rake)
    assert_false @obj.send(:production)

    create :development, [:development, :production]
    assert_equal :development, @obj.send(:state)
    assert_true @obj.send(:development)
    assert_false @obj.send(:production)
    assert_raise(ArgumentError) { @obj.send(:test) }
  end

  ############################################################################
  private
  ############################################################################

  def create(*args)
    @obj = @class.new(*args)
  end

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
