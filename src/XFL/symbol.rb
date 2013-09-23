require 'xml'
require 'XFL/edge'

# Handling edges.
module XFL
	
	# Library symbol.
	class Symbol < Struct.new(:name, :edges, :fillStyles)
		
		# Load from XFL document.
		def self.fromXFL(doc)
			fills = self.readFillStyles(doc)
			edges = doc.root.find('//xfl:Edge[@edges]').map { |edge| Edge::fromXFL(edge,fills) }
			self.new( doc.root['name'], edges, fills )
		end
		
		# Read fill styles.
		# For now, it only reads solid colors as hashes in a form `{ :color => '#RRGGBB' }`.
		# TODO: Reading more complex types of fill styles as well.
		def self.readFillStyles(doc)
			fills = []
			doc.root.find('//xfl:fills')[0].each_element do |elem|
				if elem.name == 'FillStyle' then
					index = elem['index'].to_i - 1
					color = elem.find_first('xfl:SolidColor')
					fills[index] = { :color => color['color'] }  if color
				end
			end
			fills
		end
		
	end  # class Symbol
	
end  # module XFL