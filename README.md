# chardet

Character encoding auto-detection in Ruby.

This is a Ruby 1.9-compatible version of chardet, based on the code at <http://rubyforge.org/projects/chardet/>,
which itself is a Ruby port of Mark Pilgrim's original Python code, which does not appear to be available anymore.

## Usage

    irb(main):001:0> require 'rubygems'
    => true
    irb(main):002:0> require 'UniversalDetector'
    => false
    irb(main):003:0> p UniversalDetector::chardet('hello')
    {"encoding"=>"ascii", "confidence"=>1.0}
    => nil

## Authors

* Original Python code: Mark Pilgrim
* Original Ruby port: Hui (zhengzhengzheng@gmail.com)
* Additional Ruby coding:
  * Jan (jan.h.xie@gmail.com)
  * Craig S. Cottingham (craig.cottingham@gmail.com)

## Terms of use

### Software

The Universal Encoding Detector library is copyright © 2006 Mark Pilgrim. All rights reserved.

Portions copyright © 1998-2001 Netscape Communications Corporation. All rights reserved.

The Universal Encoding Detector library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library (in a file named COPYING); if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

### Documentation

The Universal Encoding Detector documentation is copyright © 2006 Mark Pilgrim. All rights reserved.

Redistribution and use in source (XML DocBook) and “compiled” forms (SGML, HTML, PDF, PostScript, RTF and so forth) with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code (XML DocBook) must retain the above copyright notice, this list of conditions and the following disclaimer unmodified.
2. Redistributions in compiled form (transformed to other DTDs, converted to PDF, PostScript, RTF and other formats) must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS DOCUMENTATION IS PROVIDED BY THE AUTHOR “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS DOCUMENTATION, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.