# -*- encoding: utf-8 -*-

Gem::Specification.new do | s |
  s.name = 'chardet'
  s.version = '0.9.0'
  s.summary = 'Character encoding auto-detection in Ruby.'
  s.description = <<-END_OF_DESCRIPTION
This is a Ruby 1.9-compatible version of chardet, based on the code at <http://rubyforge.org/projects/chardet/>,
which itself is a Ruby port of Mark Pilgrim's original Python code, which does not appear to be available anymore.
  END_OF_DESCRIPTION
  # s.platform
  s.date = '2006-03-28'
  s.license = 'LGPL-2.1'

  s.authors = [ 'Hui', 'Jan', 'Craig S. Cottingham' ]
  s.email = [ 'zhengzhengzheng@gmail.com', 'jan.h.xie@gmail.com', 'craig.cottingham@gmail.com' ]
  s.homepage = 'https://github.com/CraigCottingham/chardet'
  # s.rubyforge_project

  s.required_ruby_version = Gem::Requirement.new('>= 1.9.3')
  # s.requirements

  s.files = `git ls-files`.split("\n")
  s.require_paths = [ 'lib' ]
  # s.bindir
  s.executables = `git ls-files -- bin/*`.split("\n").map { | f | File.basename f }
  # s.default_executable

  # s.rdoc_options
  # s.has_rdoc
  # s.extra_rdoc_files

  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  # s.add_dependency+
  # s.add_development_dependency+
end
