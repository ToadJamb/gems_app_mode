# This file contains a class to manage information about the mode that the
# executing code is running in.

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

# This class manages the mode that the executing code is running in.
class AppMode
  attr_reader :state, :valid_states

  # Tracks a global mode setting.
  @@mode = nil

  class << self
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

    # Initializes the global mode setting.
    def setup(*args)
      @@mode = self.new(*args)
    end

    ########################################################################
    private
    ########################################################################

    # Passes missing methods on to the instance.
    def method_missing(method, *args, &block)
      setup unless @@mode
      @@mode.send method, *args
    end

    # Ensure that the object knows what it can respond to via method_missing.
    # ==== Input
    # [method : Symbol] The method to check for a response to.
    # [include_private : Boolean] Whether to include private methods.
    # ==== Output
    # [Boolean] Whether the object will respond to the specified method.
    def respond_to_missing?(method, include_private)
      return true if @@mode.respond_to?(method, include_private)
      super
    end
  end

  # Constructor.
  # ==== Input
  # [env : Symbol] The environment that the mode should be set to.
  # [valid_states : Array : (:development, :test, :production)] Valid states.
  # ==== Notes
  # <tt>env</tt> must be a member of <tt>states</tt>.
  # ==== Examples
  #  Mode.new                     #=> <Mode @state=:production, @valid_states=[:development, :test, :production]>
  #  Mode.new(:test)              #=> <Mode @state=:test, @valid_states=[:development, :test, :production]>
  #  Mode.new(:dev, [:abc, :dev]) #=> <Mode @state=:dev, @valid_states=[:abc, :dev]>
  def initialize(
      state        = :production,
      valid_states = [:development, :test, :production])
    @state = state
    @valid_states = valid_states
    set_state @state
  end

  # Sets the environment instance variable.
  # ==== Input
  # [value : Symbol] The value that will be used for the environment.
  def state=(value)
    set_state value
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

  ############################################################################
  private
  ############################################################################

  # Allows the getting of the mode.
  # ==== Input
  # [method : Symbol] The method that was called.
  # [*args : Array] Any arguments that were passed in.
  # [&block : Block] A block, if specified.
  def method_missing(method, *args, &block)
    return method == @state if respond_to_missing?(method, false)
    super
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
    unless @valid_states.include?(value)
      raise "Invalid environment setting: '#{value}'."
    end

    @state = value
  end
end
