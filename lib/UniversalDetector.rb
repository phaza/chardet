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

require 'logger'
require 'singleton'

require 'EscCharSetProber'
require 'MBCSGroupProber'
require 'SBCSGroupProber'
require 'Latin1Prober'

module UniversalDetector

  class << self
    def encoding(data)
      chardet(data)['encoding']
    end

    def chardet(data)
      u = UniversalDetector::Detector.instance
      u.reset()
      u.feed(data)
      u.close()
      u.result
    end

    def log
      @log ||= Logger.new(STDOUT)
    end
  end

  log.level = Logger::INFO

  Detectiong = 0
  FoundIt = 1
  NotMe = 2

  Start = 0
  Error = 1
  ItsMe = 2

  MINIMUM_THRESHOLD = 0.20
  PureAscii = 0
  EscAscii = 1
  Highbyte = 2

  SHORTCUT_THRESHOLD = 0.95

  class Detector

    include Singleton

    attr_reader :result

    def initialize
      @_mEscCharSetProber = nil
      @_mCharSetProbers = []
      reset
    end

    def reset
      @result = {"encoding"=> nil, "confidence"=> 0.0}
      @done = false
      @_mStart = true
      @_mGotData = false
      @_mInputState = :PureAscii
      @_mLastChar = []
      @_mEscCharSetProber.reset if @_mEscCharSetProber
      @_mCharSetProbers.each { | prober | prober.reset }
    end

    def contains_escape?(data)
      return true if data.include? 0x1B

      idx = data.find_index 0x7E
      return (data[idx + 1] == 0x7B) if idx

      false
    end

    def contains_high_bit?(data)
      data.any? { | b | (b & 0x80) != 0 }
    end

    def feed(data)
      return if (@done || data.empty?)

      unless @_mGotData
        if data[0..2] == [ 0xEF, 0xBB, 0xBF ]             # UTF-8 with BOM
          UniversalDetector::log.debug 'found UTF-8 BOM'
          @result = { "encoding" => "UTF-8", "confidence" => 1.0 }
        elsif data[0..3] == [ 0xFF, 0xFE ]                # UTF-16 with little-endian BOM
          UniversalDetector::log.debug 'found UTF-16LE BOM'
          @result = { "encoding" => "UTF-16LE", "confidence" => 1.0 }
        elsif data[0..1] == [ 0xFE, 0xFF ]                # UTF-16 with big-endian BOM
          UniversalDetector::log.debug 'found UTF-16BE BOM'
          @result = { "encoding" => "UTF-16BE", "confidence" => 1.0 }
        elsif data[0..3] == [ 0xFF, 0xFE, 0x00, 0x00 ]    # UTF-32 with little-endian BOM
          UniversalDetector::log.debug 'found UTF-32LE BOM'
          @result = { "encoding" => "UTF-32LE", "confidence" => 1.0 }
        elsif data[0..3] == [ 0x00, 0x00, 0xFE, 0xFF ]    # UTF-32 with big-endian BOM
          UniversalDetector::log.debug 'found UTF-32BE BOM'
          @result = { "encoding" => "UTF-32BE", "confidence" => 1.0 }
        elsif data[0..3] == [ 0xFE, 0xFF, 0x00, 0x00 ]    # UCS-4 with unusual octet order BOM (3412)
          UniversalDetector::log.debug 'found UCS-4-3412 BOM'
          @result = { "encoding" => "X-ISO-10646-UCS-4-3412", "confidence" => 1.0 }
        elsif data[0..3] == [ 0x00, 0x00, 0xFF, 0xFE ]    # UCS-4 with unusual octet order BOM (2143)
          UniversalDetector::log.debug 'found UCS-4-2143 BOM'
          @result = { "encoding" => "X-ISO-10646-UCS-4-2143", "confidence" => 1.0 }
        end
      end

      @_mGotData = true
      if @result["encoding"] && @result["confidence"] > 0.0
        @done = true
        return
      end

      if @_mInputState == :PureAscii
        if contains_high_bit?(data)
          UniversalDetector::log.debug 'found high bit'
          @_mInputState = :Highbyte
        elsif contains_escape?(@_mLastChar + data)
          UniversalDetector::log.debug 'found escape or escape sequence'
          @_mInputState = :EscAscii
        end
      end

      @_mLastChar = data[-1]

      if @_mInputState == :EscAscii
        unless @_mEscCharSetProber
          @_mEscCharSetProber = EscCharSetProber.new
        end
        UniversalDetector::log.debug 'trying EscCharSetProber'
        if @_mEscCharSetProber.feed(data) == constants.eFoundIt
          @result = {"encoding"=> @_mEscCharSetProber.get_charset_name() ,"confidence"=> @_mEscCharSetProber.get_confidence()}
          @done = true
        end
      elsif @_mInputState == :Highbyte
        if @_mCharSetProbers.empty?
          @_mCharSetProbers = MBCSGroupProber.new.mProbers + SBCSGroupProber.new.mProbers + [Latin1Prober.new]
        end
        @_mCharSetProbers.each do | prober |
          UniversalDetector::log.debug "trying #{prober.class}"
          if prober.feed(data) == :FoundIt
            @result = {"encoding"=> prober.get_charset_name(), "confidence"=> prober.get_confidence()}
            @done = true
            break
          end
        end
      end
    end

    def close
      if @done then return end
      unless @_mGotData
        UniversalDetector::log.debug 'no data received'
        return
      end
      @done = true

      if @_mInputState == :PureAscii
        @result = {"encoding" =>  "ascii", "confidence" => 1.0}
        return @result
      end

      if @_mInputState == :Highbyte
        proberConfidence = nil
        maxProberConfidence = 0.0
        maxProber = nil

        @_mCharSetProbers.each do | prober |
          proberConfidence = prober.get_confidence()
          UniversalDetector::log.debug "#{prober.class}: #{proberConfidence}"
          if proberConfidence > maxProberConfidence
            maxProberConfidence = proberConfidence
            maxProber = prober
          end
        end
        if maxProber and (maxProberConfidence > MINIMUM_THRESHOLD)
          @result = { "encoding" => maxProber.get_charset_name(), "confidence" => maxProber.get_confidence() }
          return @result
        end
      end

      UniversalDetector::log.debug 'no probers hit minimum threshhold'
    end
  end

end
