require 'xml'

module SVG


# Convert the opcode symbol to SVG vector command.
def SVG.opSymToSVG(sym)
	return { :moveTo => 'M', :lineTo => 'L', :curveTo => 'Q', :cubicTo => 'C' }[sym]
end


# Create an SVG path element from the given array with edge data.
def SVG.path(edgeArr)
	pathElem = XML::Node.new('path')
	pathElem['d'] = edgeArr.map { |opcode,*params| [ opSymToSVG(opcode), *params ] }.join(' ')
	return pathElem
end


end # module SVG