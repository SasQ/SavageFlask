require 'xml'
require_relative 'edge'

# Handling edges.
module XFL
	
	# Library symbol.
	class Symbol < Struct.new(:edges)
		
		def self.fromXFL(doc)
			# Find all `Edge` elements with `edges` attribute.
			edges = doc.root.find('//xfl:Edge[@edges]')
				puts "Edges in the XFL file:"  # Just for debug. It will be removed in next commit.
				edges.each { |edge| p edge }
			
			# Construct an `Edge` object from each `Edge` element.
			edges = edges.map { |edge| Edge.new( edge['edges'] ) }
			
			# Return new element filled with these data.
			sym = self.new
			sym.edges = edges
			sym
		end
		
	end  # class Symbol
	
end  # module XFL