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
		
		
		# Adds the given edge to the group for the given fill style.
		# If the style doesn't exist yet, a new empty group (an array) is created for it on-the-fly.
		def addEdgeToGroup(edgeGroups,group,edge)
			edgeGroups[group] = []  if !edgeGroups.has_key?(group)  # Prepare new array if this is a new group.
			edgeGroups[group] << edge
		end
		
		
		# Get filled areas.
		def filledAreas
			# First, we need to unshare the common edges by duplicating them for both fills (left and right).
			# To facilitate grouping of these edges, we already sort them by their fill styles.
			edgeGroups = {}
			edges.each do |edge|
				addEdgeToGroup(edgeGroups, edge.leftFill,  edge)          if edge.leftFill  != nil
				addEdgeToGroup(edgeGroups, edge.rightFill, edge.reverse)  if edge.rightFill != nil
			end
			edgeGroups
		end
		
	end  # class Symbol
	
end  # module XFL