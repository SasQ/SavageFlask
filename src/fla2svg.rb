#!/usr/bin/ruby

APP_VERSION = '0.1 (alpha)'
APP_AUTHOR  = 'Mike \'SasQ\' Studencki'
APP_EMAIL   = '<sasq1@go2.pl>'


# Say hello.
puts "XFL to SVG converter v.#{APP_VERSION} written in Ruby by #{APP_AUTHOR}."
puts "Report any bugs to #{APP_EMAIL}."
puts


# Read some data from the XFL file.

filename = '../TestData/Hair.xml'

require 'xml'

# Open the XFL file and parse its content.
parser = XML::Parser.file(filename)
doc = parser.parse

# NOTICE: XFL elements live in a namespace.
# We need to set it up as the default namespace for XPath queries to work.
doc.root.namespaces.default_prefix = 'xfl'


# FIXME: Relative paths should be relative to the script, not the current working directory.
require './XFL/edge'
include XFL

# Load edges from XFL.
sym = XFL::Symbol.fromXFL(doc)
edge = sym.edges[0]
edgeData = edge.commands  # Let's try it on the first edge.

puts "\nFirst edge loaded:\n#{edge.commands.inspect}"

# Simplify the path data.
edge.simplifyPath!
puts "\nand simplified:\n#{edge.commands}"

puts "\nThis edge goes from (#{edge.startPoint}) to (#{edge.endPoint})"


# Let's try to spit it out as SVG path.
require './SVG/path'
puts "\nConverting to SVG path:"
pathElem = SVG::path(edge.commands)
p pathElem


# TODO: Next step: Edges as objects.