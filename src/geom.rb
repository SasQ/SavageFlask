# Geometry utilities.
module Geom
	
	# Stores coordinates of a 2D point.
	class Point
		attr_accessor :x, :y
		
		def initialize(x=0, y=0)
			@x = x;  @y = y
		end
		
		# Points are the same when their coordinates are equal.
		def ==(other)
			@x == other.x and @y == other.y
		end
		
		# Might be useful sometimes.
		def to_a
			return [@x, @y]
		end
	end
	
end