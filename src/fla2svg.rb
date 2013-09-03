#!/usr/bin/ruby

APP_VERSION = '0.1 (alpha)'
APP_AUTHOR  = 'Mike \'SasQ\' Studencki'
APP_EMAIL   = '<sasq1@go2.pl>'


# Say hello.
puts "XFL to SVG converter v.#{APP_VERSION} written in Ruby by #{APP_AUTHOR}."
puts "Report any bugs to #{APP_EMAIL}."
puts


filename = '../TestData/Hair.xml'

require 'xml'

# Open the XFL file and parse its content.
parser = XML::Parser.file(filename)
doc = parser.parse


# NOTICE: XFL elements live in a namespace.
# We need to set it up as the default namespace for XPath queries to work.
doc.root.namespaces.default_prefix = 'xfl'

# Find all `Edge` elements with `edges` attribute.
edges = doc.root.find('//xfl:Edge[@edges]')


# Some tests of the new classes for commands and points.
require './geom'
require './XFL/edge'
require './XFL/commands'

include XFL
include Geom

mt = Command::MoveTo.new(10,20)
lt = Command::LineTo.new( [10,20] )
ct = Command::CurveTo.new( Point.new(30,40), Point.new(50,60) )
puts "MoveTo(#{mt.endPoint.x},#{mt.endPoint.y})"
puts "LineTo(#{lt.endPoint.x},#{lt.endPoint.y})"
puts "CurveTo(#{ct.controlPoint.x},#{ct.controlPoint.y},#{ct.endPoint.x},#{ct.endPoint.y})"
print 'Same endpoints for MoveTo and LineTo? ';  p mt.endPoint == lt.endPoint
print 'Same endpoints for MoveTo and CurveTo? '; p mt.endPoint == ct.endPoint
puts


# For starters, let's just read the edge data into a nested array of commands.
# Each command is an array of the form: `[ opcode, *parameters ]`
# where `parameters` is just a series of coordinate numbers.
# We will also use Ruby symbols for the opcodes, for better readability and efficiency.

puts "Edges:"
edges.each { |edge| p edge }

# Let's try it on the first edge.
edgeData = edges[0]['edges']

puts "\nConverting this:"
p edgeData

puts "\ninto this:"
edgeArr = Edge::edgeData2arr(edgeData)
p edgeArr


# Simplify the path data.
Edge::simplifyPath!(edgeArr)


# Let's try to spit it out as SVG path.
require './SVG/path'
puts "\nConverting to SVG path:"
pathElem = SVG::path(edgeArr)
p pathElem


# TODO: Next step: Commands as objects maybe?