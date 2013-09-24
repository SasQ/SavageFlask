#!/usr/bin/ruby

APP_VERSION = '0.1 (alpha)'
APP_AUTHOR  = 'Mike \'SasQ\' Studencki'
APP_EMAIL   = '<sasq1@go2.pl>'


# Add current source's root directory to the search path.
$LOAD_PATH.unshift( File.expand_path( File.dirname(__FILE__) ) )


# Say hello.
puts "XFL to SVG converter v.#{APP_VERSION} written in Ruby by #{APP_AUTHOR}."
puts "Report any bugs to #{APP_EMAIL}."
puts


# For now, let's suppose that the only command line argument is the name of the XFL file to read.
if ARGV.length == 0
	puts 'Usage:'
	puts 'fla2svg XFLfile.xml'
	exit 0
end

filename = ARGV[-1]

if !File.exist?(filename)
	puts 'XFL file not found: '
	puts File.expand_path(filename)
	exit -1
end

puts "Reading XFL file: #{filename}"


# Read some data from the XFL file.

require 'xml'

# Open the XFL file and parse its content.
parser = XML::Parser.file(filename)
doc = parser.parse

# NOTICE: XFL elements live in a namespace.
# We need to set it up as the default namespace for XPath queries to work.
doc.root.namespaces.default_prefix = 'xfl'

require 'XFL/symbol'
require 'XFL/edge'
include XFL

# Load symbol from XFL.
sym = XFL::Symbol.fromXFL(doc)

puts "\nSymbol name:\n#{sym.name}"


# Load fill styles from XFL.
puts "\nFound fill styles:\n#{sym.fillStyles}"


# Let's try to spit it out as SVG path.
require 'SVG/path'
puts "\nConverting to SVG path:"
p pathElem = SVG::path( sym.edges[0] )


# Just for debug: pretty-printing.
def printAreas(areas)
	areas.each do |key,value|
		print key.to_a[0][1]; puts ':'
		value.each { |edge| puts "#{edge.commands}" }
		puts
	end
end


# Test for finding filled areas.
puts "\nFilled areas:\n\n"
areas = sym.filledAreas
printAreas(areas)

# Test for joining the filled region's contour.
puts "\nLet's try to join some contour for one filled area:"
edgeGroup = areas[ sym.fillStyles[0] ]
contour = edgeGroup[0].append(edgeGroup[1]).append(edgeGroup[2]).append(edgeGroup[3]).append(edgeGroup[4]).append(edgeGroup[5])
p contour

puts "\nand convert it to SVG path:"
p SVG::path(contour)


# TODO: Next step: Finding filled areas.