# This file overrides the main class during tests.

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

class AppMode
  ############################################################################
  private
  ############################################################################

  def origin
    case @valid_states[0]
      when /^dev_/
        "./file_name.rb:00:in `<main>'"
      when /^test_test_class/, /^test_class_test/,
          /^tests_test_class/, /^tests_class_test/
        path = @valid_states[0].to_s
        folder = path.match(/^(\w+?)_/)[1].to_s
        file = path.match(/^\w+?_(\w+?_\w+?)_/)[1].to_s
        "./#{folder}/#{file}.rb:33:in `<main>'"
      when /^test_/
        "/root/ruby/gems/ruby-9.8.7-p123/gems/rake-6.5.4/lib/rake/" +
        "rake_test_loader.rb:5:in `<main>'"
      when /^rake_/
        "/root/ruby/gems/ruby-9.8.7-p123/bin/rake:19:in `<main>'"
      else
        "./root/file_name.rb:00:in `<main>'"
    end
  end
end
