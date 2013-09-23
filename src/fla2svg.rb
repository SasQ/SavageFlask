#!/usr/bin/ruby

APP_VERSION = '0.1 (alpha)'
APP_AUTHOR  = 'Mike \'SasQ\' Studencki'
APP_EMAIL   = '<sasq1@go2.pl>'


# Say hello.
puts "XFL to SVG converter v.#{APP_VERSION} written in Ruby by #{APP_AUTHOR}."
puts "Report any bugs to #{APP_EMAIL}."
puts


# Some tests of the new classes for commands and points.
# TODO: These tests are no longer needed. Scheduled for remove with next commit.
# FIXME: Relative paths shoudl be relative to the script, not the current working directory.
require './geom'
require './XFL/edge'
require './XFL/commands'

include XFL
include Geom

p mt = Command::MoveTo.new(10,20)
p lt = Command::LineTo.new( [10,20] )
p ct = Command::CurveTo.new( Point.new(30,40), Point.new(50,60) )
print 'Same endpoints for MoveTo and LineTo? ';  p mt.endPoint == lt.endPoint
print 'Same endpoints for MoveTo and CurveTo? '; p mt.endPoint == ct.endPoint
puts

# Now it's time to read some data from the XFL file.

filename = '../TestData/Hair.xml'

require 'xml'

# Open the XFL file and parse its content.
parser = XML::Parser.file(filename)
doc = parser.parse

# NOTICE: XFL elements live in a namespace.
# We need to set it up as the default namespace for XPath queries to work.
doc.root.namespaces.default_prefix = 'xfl'


# Load edges from XFL.
sym = XFL::Symbol.fromXFL(doc)
edges = sym.edges


# For starters, let's just read the edge data into a nested array of commands.
# Each command is an array of the form: `[ opcode, *parameters ]`
# where `parameters` is just a series of coordinate numbers.
# We will also use Ruby symbols for the opcodes, for better readability and efficiency.

# Let's try it on the first edge.
edgeData = edges[0]['edges']

puts "\nConverting this:"
p edgeData

puts "\ninto this:"
edge = Edge.new(edgeData)
p edge.commands


# Simplify the path data.
edge.simplifyPath!
puts "\nAfter simplification:"
p edgeArr = edge.commands

puts "\nThis path goes from (#{edge.startPoint}) to (#{edge.endPoint})"


# Let's try to spit it out as SVG path.
require './SVG/path'
puts "\nConverting to SVG path:"
pathElem = SVG::path(edgeArr)
p pathElem


# TODO: Next step: Edges as objects.