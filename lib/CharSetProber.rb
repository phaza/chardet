# -*- encoding: utf-8 -*-

######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Hui (zhengzhengzheng@gmail.com) - port to Ruby
#   Mark Pilgrim - first port to Python
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

# require 'UniversalDetector'

module  UniversalDetector

    class CharSetProber
        def reset
            @_mState = :Detecting
        end

        def get_charset_name
            return nil
        end

        def feed(data)
        end

        def get_state
            return @_mState
        end

        def get_confidence
            return 0.0
        end

        def filter_high_bit_only(aBuf)
            # aBuf.gsub(/([\x00-\x7F])+/, '')
            aBuf.select { | b | (b & 0x80) != 0 }
        end

        def filter_without_english_letters(aBuf)
            # aBuf.gsub(/([A-Za-z])+/, '')
            aBuf.reject { | b | ((b >= 0x41) && (b <= 0x5A)) || ((b >= 0x61) && (b <= 0x7A)) }
        end

        def filter_with_english_letters(aBuf)
            # aBuf.gsub(/([^A-Za-z])+/, '')
            aBuf.select { | b | ((b >= 0x41) && (b <= 0x5A)) || ((b >= 0x61) && (b <= 0x7A)) }
        end

    end #class

end #module