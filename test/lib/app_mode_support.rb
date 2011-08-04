# This file contains a module which bridges the gap between test code
# and applciation code.

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

# This module is provided to be used as an include in any necessary class.
#
# This serves as a bridge between test code and application code.
module AppModeSupport
  # These are things that will be used throughout testing in multiple locations.
  ITEMS = {
    :states => {
      :default => [:development, :test, :production],
    }, # :states

    :method_list => {
      :valid_states => :valid_states,
      :state        => :state,
    }, # :methods
  } # ITEMS

  # Black magic.
  #
  # This is used for the following purposes:
  # * To return elements from the ITEMS hash.
  # * To return messages (from the ITEMS hash),
  #   possibly with string substitutions.
  # ==== Input
  # [method : Symbol] The method that was called.
  # [*args : Array] Any arguments that were passed in.
  # [&block : Block] A block, if specified.
  # ==== Output
  # [Any] It depends on the method.
  def method_missing(method, *args, &block)
    # Check if the method is a key in the ITEMS hash.
    if ITEMS.has_key? method
      # Initialize the variable that will hold the return value.
      value = nil

      if args.nil? or args.count == 0
        # If no arguments have been specified, return the element as is.
        value = ITEMS[method]
      elsif ITEMS[method][args[0]].is_a?(String) &&
          ITEMS[method][args[0]].index('%s')
        # The first parameter is the message.
        msg = args.shift

        if args.count == 0
          # If no arguments are left, return the message.
          value = ITEMS[method][msg]
        else
          # Use any remaining arguments to make substitutions.
          value = ITEMS[method][msg] % args
        end
      else # All other methods - which are expected to have one parameter.
        # Get the element to return.
        item = args[0].to_sym

        # Return the indicated element.
        value = ITEMS[method][item]
      end

      # Strip all trailing line feeds from strings.
      value.gsub!(/\n*\z/, '') if value.is_a?(String)

      return value
    else
      super
    end
  end

  # Indicates which methods the class will respond to.
  # ==== Input
  # [method : Symbol] The method to check for.
  # [include_private : Boolean] Whether private methods should be checked.
  # ==== Output
  # [Boolean] Whether the object will respond to the specified method.
  def respond_to_missing?(method, include_private = false)
    if ITEMS.has_key? method
      return true
    else
      super
    end
  end
end
