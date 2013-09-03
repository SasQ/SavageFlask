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

mt = XFL::Command::MoveTo.new(10,20)
lt = XFL::Command::LineTo.new( Geom::Point.new(10,20) )
ct = XFL::Command::CurveTo.new( Geom::Point.new(30,40), Geom::Point.new(50,60) )
puts "MoveTo(#{mt.endPoint.x.to_s},#{mt.endPoint.y.to_s})"
puts "LineTo(#{lt.endPoint.x.to_s},#{lt.endPoint.y.to_s})"
puts "CurveTo(#{ct.controlPoint.x.to_s},#{ct.controlPoint.y.to_s},#{ct.endPoint.x.to_s},#{ct.endPoint.y.to_s})"
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
edgeArr = XFL::Edge::edgeData2arr(edgeData)
p edgeArr


# Simplify the path data.
XFL::Edge::simplifyPath!(edgeArr)


# Let's try to spit it out as SVG path.
require './SVG/path'
puts "\nConverting to SVG path:"
pathElem = SVG::path(edgeArr)
p pathElem


# TODO: Next step: Commands as objects maybe?