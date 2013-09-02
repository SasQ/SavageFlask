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

# Print the document (just for testing).
p doc

# Now let's try finding some elements.
# NOTICE: XFL elements live in a namespace.
# We need to set it up as the default namespace for XPath queries to work.
doc.root.namespaces.default_prefix = 'xfl'

edges = doc.root.find('//xfl:Edge[@edges]')
edges.each { |edge| p edge }

# Seems to work :>
# TODO: Next step: Parsing edge data.