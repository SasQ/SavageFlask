require 'xml'

# Extend the commands classes to support converting to SVG commands.
module XFL::Command
	
	class MoveTo
		def toSVG
			"M #{endPoint.x} #{endPoint.y}"
		end
	end
	
	class LineTo
		def toSVG
			"L #{endPoint.x} #{endPoint.y}"
		end
	end
	
	class CurveTo
		def toSVG
			"Q #{controlPoint.x} #{controlPoint.y} #{endPoint.x} #{endPoint.y}"
		end
	end
	
end  # module XFL::Command


module SVG
	
	# Create an SVG path element from the given `Edge` object.
	def SVG.path(edge)
		pathElem = XML::Node.new('path')
		if edge.rightFill != nil and edge.rightFill.has_key?(:color)
			pathElem['fill'] = edge.rightFill[:color]
		end
		pathElem['d'] = edge.commands.map { |cmd| cmd.toSVG }.join(' ')
		pathElem
	end
	
end # module SVG