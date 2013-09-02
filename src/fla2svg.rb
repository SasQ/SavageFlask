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
# Each command is an array of the form: `[ opcode, *parameters ]`
# where `parameters` is just a series of coordinate numbers.
# We will also use Ruby symbols for the opcodes, for better readability and efficiency.

# Convert XFL opcodes to human-readable symbols.
def opStrToSym(opcodeStr)
	return { '!' => :moveTo, '|' => :lineTo, '/' => :lineTo, '[' => :curveTo, '(' => :cubicTo }[opcodeStr]
end

# Converts 32-bit fixed-point number from hexadecimal string to its corresponding number.
# TODO: Account for incomplete fractional bytes.
def hexToNum(hexstr)
	num = hexstr.gsub('.','').hex
	num = (num >= '80000000'.hex)  ?  -('FFFFFFFF'.hex - num + 1)  :  num
	num.to_f / 256
end

# Read XFL edge data string into a nested array.
# Numbers are decoded as floating point values with correct scale.
def edgeData2arr(edgeData)
	edgeData.scan( /([!|\/\[])([^!|\/\[]+)/ ).map do |opcode,params|
		numbers = params.scan( /(#?)(\S+)\s*/ ).map do |prefix,number|
			prefix == '#'  ?  hexToNum(number)  :  number.to_f / 20
		end
		[ opStrToSym(opcode), *numbers ]
	end
end


# Let's try it on the first edge.
edgeData = edges[0]['edges']

puts "\nConverting this:"
p edgeData

puts "\ninto this:"
edgeArr = edgeData2arr(edgeData)
p edgeArr


# Simplify the path data.

# Return the command's opcode.
def cmdOp(cmd)
	return cmd[0]  # First item is the opcode.
end

# Return the command's destination point.
def cmdTo(cmd)
	return cmd[-2..-1]  # Last two numbers are always the endpoint.
end

# TODO: If we make command to be a class, the above functions can be then turned into its methods.

# Simplify the edge data:
# If a `moveTo` command has the same coordinates as the endpoint of the preceding command,
# it is redundant and can be safely removed.
def simplifyPath!(edgeArr)
	edgeArr.each_with_index do |cmd,index|
		next unless cmdOp(cmd) == :moveTo or index > 0
		prevCmd = edgeArr[index-1]
		edgeArr.delete_at(index) if cmdTo(prevCmd) == cmdTo(cmd)
	end
end


simplifyPath!(edgeArr)


# Let's try to spit it out as SVG path.

# Convert the opcode symbol to SVG vector command.
def opSymToSVG(sym)
	return { :moveTo => 'M', :lineTo => 'L', :curveTo => 'Q', :cubicTo => 'C' }[sym]
end

# Create an SVG path element from the given array with edge data.
def SVG_path(edgeArr)
	pathElem = XML::Node.new('path')
	pathElem['d'] = edgeArr.map { |opcode,*params| [ opSymToSVG(opcode), *params ] }.join(' ')
	return pathElem
end


puts "\nConverting to SVG path:"
pathElem = SVG_path(edgeArr)
p pathElem


# TODO: Next step: Modularization and cleaning up.