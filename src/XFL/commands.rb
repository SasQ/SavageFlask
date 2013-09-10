require_relative '../geom'

module XFL module Command
	
	Point = ::Geom::Point
	
	class MoveTo < Struct.new(:endPoint)
		
		# Possible forms of initialization:
		# MoveTo.new( x, y )
		# MoveTo.new( [x, y] )
		# MoveTo.new( Point(x,y) )
		def initialize(*args)
			if    args[0].is_a?(Point) then super( args[0] )
			elsif args[0].is_a?(Array) then super( Point.new( args[0][0], args[0][1] ) )
			elsif args.is_a?(Array)    then super( Point.new( args[0],    args[1]    ) )
			end
		end
		
		def inspect
			"MoveTo(#{endPoint})"
		end
		
	end
	
	
	class LineTo < Struct.new(:endPoint)
		
		# Possible forms of initialization:
		# LineTo.new( x, y )
		# LineTo.new( [x, y] )
		# LineTo.new( Point(x,y) )
		def initialize(*args)
			if    args[0].is_a?(Point) then super( args[0] )
			elsif args[0].is_a?(Array) then super( Point.new( args[0][0], args[0][1] ) )
			elsif args.is_a?(Array)    then super( Point.new( args[0],    args[1]    ) )
			end
		end
		
		def inspect
			"LineTo(#{endPoint})"
		end
	end
	
	class CurveTo  < Struct.new(:controlPoint, :endPoint)
		
		# Possible forms of initialization:
		# CurveTo.new( cx, cy, x, y )
		# CurveTo.new( [cx, cy], [x, y] )
		# CurveTo.new( Point(cx,cy), Point(x,y) )
		def initialize(*args)
			if args[0].is_a?(Point)
				super( args[0], args[1] )
			elsif args[0].is_a?(Array) and args[1].is_a?(Array)
				super( Point.new( args[0][0], args[0][1] ), Point.new( args[1][0], args[1][1] ) )
			elsif args.is_a?(Array)
				super( Point.new( args[0], args[1] ), Point.new( args[2], args[3] ) )
			end
		end
		
		def inspect
			"CurveTo(#{controlPoint}, #{endPoint})"
		end
	end
	
end end  # module XFL::Command