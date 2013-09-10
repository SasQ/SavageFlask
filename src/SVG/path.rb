require 'xml'

# Extend the commands classes to support converting to SVG commands.
module XFL::Command
	
	class MoveTo
		def toSVG
			return "M #{endPoint.x} #{endPoint.y}"
		end
	end
	
	class LineTo
		def toSVG
			return "L #{endPoint.x} #{endPoint.y}"
		end
	end
	
	class CurveTo
		def toSVG
			return "Q #{controlPoint.x} #{controlPoint.y} #{endPoint.x} #{endPoint.y}"
		end
	end
	
end  # module XFL::Command


module SVG
	
	# Create an SVG path element from the given array with edge data.
	def SVG.path(edgeArr)
		pathElem = XML::Node.new('path')
		pathElem['d'] = edgeArr.map { |cmd| cmd.toSVG }.join(' ')
		return pathElem
	end
	
end # module SVG