require 'xml'
require_relative 'edge'

# Handling edges.
module XFL
	
	# Library symbol.
	class Symbol < Struct.new(:name, :edges)
		
# 		# Load from XFL document.
		def self.fromXFL(doc)
			self.new(
				doc.root['name'],
				doc.root.find('//xfl:Edge[@edges]').map { |edge| Edge::fromXFL(edge) }
			)
		end
		
	end  # class Symbol
	
end  # module XFL