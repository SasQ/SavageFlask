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

# Let's try finding some elements.
# NOTICE: XFL elements live in a namespace.
# We need to set it up as the default namespace for XPath queries to work.
doc.root.namespaces.default_prefix = 'xfl'

puts "Edges:"
edges = doc.root.find('//xfl:Edge[@edges]')
edges.each { |edge| p edge }


# For starters, let's just read the edge data into a nested array of commands.
# Each item of this array has the format: `[ command [ parameters ] ]`
# where `parameters` are just coordinate numbers.
# We will also use human-readable names (Ruby symbols for efficiency) for the commands.

edgeData = edges[0]['edges']

puts "\nConverting this:"
p edgeData


# Converts XFL opcodes to human-readable symbols.
def cmdToSym(cmdstr)
	return {'!' => :moveTo, '|' => :lineTo, '/' => :lineTo, '[' => :curveTo, '(' => :cubicTo }[cmdstr]
end

# Converts 32-bit fixed-point number from hexadecimal string to its corresponding number.
# TODO: Account for incomplete fractional bytes.
def hexToNum(hexstr)
	num = hexstr.gsub('.','').hex
	num = (num >= '80000000'.hex)  ?  -('FFFFFFFF'.hex - num + 1)  :  num
	num.to_f / 256
end

# Reads XFL edge data string into a nested array.
# Numbers are already decoded as floating point values with correct scale.
def edgeData2arr(edgeData)
	edgeData.scan( /([!|\/\[])([^!|\/\[]+)/ ).map do |cmd,ops|
		numbers = ops.scan( /(#?)(\S+)\s*/ ).map do |prefix,num|
			prefix == '#'  ?  hexToNum(num)  :  num.to_f / 20
		end
		[ cmdToSym(cmd), *numbers ]
	end
end

puts "\ninto this:"
p edgeData2arr(edgeData)


# TODO: Next step: Parsing edge data.