# Geometry utilities.
module Geom
	
	# Stores coordinates of a 2D point.
	class Point < Struct.new(:x, :y)
		
		def initialize(x=0, y=0)
			super(x,y)
		end
		
		# Points are the same when their coordinates are equal.
		# ### Not needed anymore, since `Struct` defines it already. Remove in next commit. ###
		#def ==(other)
		#	@x == other.x and @y == other.y
		#end
		
		# Convert to string.
		def to_s
			"#{x},#{y}"
		end
		
		# Convert to array.
		def to_a
			return [x, y]
		end
		
	end
	
end  # module Geom