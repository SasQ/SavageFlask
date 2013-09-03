require 'xml'

# Extend the commands classes to support converting to SVG commands.
class XFL::Command::MoveTo
	def toSVG
		return "M #{@endPoint.x} #{@endPoint.y}"
	end
end

class XFL::Command::LineTo
	def toSVG
		return "L #{@endPoint.x} #{@endPoint.y}"
	end
end

class XFL::Command::CurveTo
	def toSVG
		return "Q #{@controlPoint.x} #{@controlPoint.y} #{@endPoint.x} #{@endPoint.y}"
	end
end


module SVG
	
	
	# Convert the opcode symbol to SVG vector command.
	def SVG.opSymToSVG(sym)
		return { :moveTo => 'M', :lineTo => 'L', :curveTo => 'Q', :cubicTo => 'C' }[sym]
	end
	
	
	# Create an SVG path element from the given array with edge data.
	def SVG.path(edgeArr)
		pathElem = XML::Node.new('path')
		pathElem['d'] = edgeArr.map { |cmd| cmd.toSVG }.join(' ')
		return pathElem
	end
	
	
end # module SVG