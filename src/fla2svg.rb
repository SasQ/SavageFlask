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

require 'XFL/edge'

puts "Edges:"
edges.each { |edge| p edge }


# For starters, let's just read the edge data into a nested array of commands.
# Each command is an array of the form: `[ opcode, *parameters ]`
# where `parameters` is just a series of coordinate numbers.
# We will also use Ruby symbols for the opcodes, for better readability and efficiency.

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
require 'SVG/path'
puts "\nConverting to SVG path:"
pathElem = SVG::path(edgeArr)
p pathElem


#XFL::Edge::hexToNum('a9')            # cannot call, private (good)
#XFL::Edge::cmdOp([:moveTo, 10,20])   # cannot call, private (good)


# TODO: Next step: Commands as objects maybe?