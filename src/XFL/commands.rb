require_relative '../geom'

module XFL
	module Command
		
		Point = ::Geom::Point
		
		class MoveTo
			attr_accessor :endPoint
			
			# Possible forms of initialization:
			# MoveTo.new( x, y )
			# MoveTo.new( [x, y] )
			# MoveTo.new( Point(x,y) )
			def initialize(*args)
				if args[0].is_a?(Point)    then @endPoint = args[0]
				elsif args[0].is_a?(Array) then @endPoint = Point.new( args[0][0], args[0][1] )
				elsif args.is_a?(Array)    then @endPoint = Point.new( args[0],    args[1]    )
				end
			end
		end
		
		class LineTo
			attr_accessor :endPoint
			
			# Possible forms of initialization:
			# LineTo.new( x, y )
			# LineTo.new( [x, y] )
			# LineTo.new( Point(x,y) )
			def initialize(*args)
				if args[0].is_a?(Point)    then @endPoint = args[0]
				elsif args[0].is_a?(Array) then @endPoint = Point.new( args[0][0], args[0][1] )
				elsif args.is_a?(Array)    then @endPoint = Point.new( args[0],    args[1]    )
				end
			end
		end
		
		class CurveTo
			attr_accessor :controlPoint, :endPoint
			
			# Possible forms of initialization:
			# CurveTo.new( cx, cy, x, y )
			# CurveTo.new( [cx, cy], [x, y] )
			# CurveTo.new( Point(cx,cy), Point(x,y) )
			def initialize(*args)
				if args[0].is_a?(Point) then
					@controlPoint = args[0]
					@endPoint     = args[1]
				elsif args[0].is_a?(Array) and args[1].is_a?(Array) then
					@controlPoint = Point.new( args[0][0], args[0][1] )
					@endPoint     = Point.new( args[1][0], args[1][1] )
				elsif args.is_a?(Array) then
					@controlPoint = Point.new( args[0], args[1] )
					@endPoint     = Point.new( args[2], args[3] )
				end
			end
		end
		
	end  # module Command
end  # module XFL