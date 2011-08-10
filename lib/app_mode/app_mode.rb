# This file contains a global class to manage information about the mode
# that the executing code is running in.

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
class AppMode < StateManager
  # Tracks a global mode setting.
  @@mode = nil

  class << self
    # Override the send method.
    #
    # This was implemented to cover the case where test is used as a state.
    # In that case, the default behavior was to call the private
    # test method from Kernel. This prevents that behavior in cases where a
    # public method is available via method_missing in the parent class.
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
end
