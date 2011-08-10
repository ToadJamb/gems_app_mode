# This file contains a class to manage information about the state of
# a module, class, object, or application.

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

# This class assists in managing the state of
# a module, class, object, or application.
class StateManager
  attr_reader :state, :valid_states

  # Constructor.
  # ==== Input
  # [state : Symbol] The state that should be used initially.
  #
  #                  :dynamic is a special state that will determine the best
  #                  state based on the environment that the code is running in.
  # [valid_states : Array : (:development, :test, :production)] Valid states.
  # ==== Notes
  # <tt>env</tt> must be a member of <tt>states</tt>.
  # ==== Examples
  #  StateManager.new                     #=> <StateManager @state=:rake, @valid_states=[:development, :test, :rake, :production]>
  #  StateManager.new(:test)              #=> <StateManager @state=:test, @valid_states=[:development, :test, :rake, :production]>
  #  StateManager.new(:dev, [:abc, :dev]) #=> <StateManager @state=:dev, @valid_states=[:abc, :dev]>
  def initialize(
      state        = :dynamic,
      valid_states = [:development, :test, :rake, :production])
    @state = state
    @valid_states = valid_states
    set_state @state
  end

  # Override the send method.
  #
  # This was implemented to cover the case where test is used as a state.
  # In that case, the default behavior was to call the private
  # test method from Kernel. This prevents that behavior in cases where a
  # public method is available via method_missing in this class.
  def send(method, *args)
    return method_missing(method, *args) if respond_to_missing?(method, false)
    super
  end

  # Sets the state instance variable.
  # ==== Input
  # [value : Symbol] The value that will be used for the state.
  def state=(value)
    set_state value
  end

  ############################################################################
  private
  ############################################################################

  # Returns the appropriate state to use when setting the state dynamically.
  # ==== Output
  # [Symbol] The state that should be used when setting the state dynamically.
  def dynamic_state
    call = origin
    return @valid_states[0] unless call.sub(/^\.\//, '').match(/\//)

    case call
      when /rake_test_loader\.rb/,
          %r[/tests?/test_\w+?.rb], %r[/tests?/\w+?_test.rb]
        return @valid_states[1]
      when %r[/bin/rake]
        return @valid_states[2]
    end

    return @valid_states.last
  end

  # Allows the getting of the state since valid states
  # may be specified at run time.
  # ==== Input
  # [method : Symbol] The method that was called.
  # [*args : Array] Any arguments that were passed in.
  # [&block : Block] A block, if specified.
  def method_missing(method, *args, &block)
    return method == @state if respond_to_missing?(method, false)
    super
  end

  # Returns the first call in the stack.
  # ==== Output
  # [String] The file that made the first call in the stack.
  # ==== Notes
  # This method is overridden during tests.
  def origin
    caller.last
  end

  # Ensure that the object knows what it can respond to via method_missing.
  # ==== Input
  # [method : Symbol] The method to check for a response to.
  # [include_private : Boolean] Whether to include private methods.
  # ==== Output
  # [Boolean] Indicates whether the object will respond to the specified method.
  def respond_to_missing?(method, include_private)
    return true if @valid_states.include?(method)
    super
  end

  # Sets the state.
  # ==== Input
  # [value : Symbol] The value to use for the state.
  def set_state(value)
    unless @valid_states.include?(value) || value == :dynamic
      raise "Invalid environment setting: '#{value}'."
    end

    if value == :dynamic
      @state = dynamic_state || @valid_states.last
    else
      @state = value
    end
  end
end
