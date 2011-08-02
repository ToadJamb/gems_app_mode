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

require File.join(File.dirname(File.expand_path(__FILE__)), 'require')

class ModeTest < Test::Unit::TestCase
  include ModeSupport

  def test_class_type
    assert_equal Mode, @class
  end

  def test_default_settings
    create
    assert_equal :production, @obj.state
    assert_equal states(:default), @obj.valid_states
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
    assert_true @obj.test
    assert_false @obj.development
    assert_false @obj.production

    create :development
    assert_equal :development, @obj.state
    assert_true @obj.development
    assert_false @obj.test
    assert_false @obj.production

    create :production
    assert_equal :production, @obj.state
    assert_false @obj.development
    assert_false @obj.test
    assert_true @obj.production
  end

  def test_invalid_state
    assert_raise(RuntimeError) { create :invalid }
    assert_raise(NoMethodError) { create :test; if @obj.invalid; end }
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
    assert_true @obj.send(:test)
    assert_false @obj.send(:production)
    assert_false @obj.send(:development)

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
end
