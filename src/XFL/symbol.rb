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
		
		
		# Search in the array of `edges` to find the edge which starts where the given edge ends.
		# If found, the edge is removed from the original array.
		def findConnectedTo(prevEdge,edges)
			edges.each_with_index do |edge,index|
				return index  if edge.startPoint == prevEdge.endPoint
			end
			-1
		end
		
		
		# Find the segments of a closed contour and join them together in the correct order.
		# The contour found is then removed from the group.
		def findContour(group)
			contour = group.delete_at(0)
			while !contour.closed? and group.length > 0 and at = findConnectedTo(contour,group)
				contour = contour.append( group[at] )
				group.delete_at(at)
			end
			contour
		end
		
		
		# Find all closed contours in a given edge group.
		def findContours(group)
			contours = []
			while group.length > 0
				contours << findContour(group)
			end
			contours
		end
		
		
		# Get filled regions.
		def filledRegions
			# First, we need to unshare the common edges by duplicating them for both fills (left and right).
			# To facilitate grouping of these edges, we already sort them by their fill styles.
			edgeGroups = {}
			edges.each do |edge|
				addEdgeToGroup(edgeGroups, edge.leftFill,  edge)          if edge.leftFill  != nil
				addEdgeToGroup(edgeGroups, edge.rightFill, edge.reverse)  if edge.rightFill != nil
			end
			
			# Next, we need to join fragments of closed contours together in the correct order.
			filledRegs = {}
			edgeGroups.each do |fillStyle,group|
				filledRegs[fillStyle] = findContours(group)
			end
			filledRegs
		end
		
	end  # class Symbol
	
end  # module XFL