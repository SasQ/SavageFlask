require 'XFL/commands'

# Handling edges.
module XFL
	
	# Edge data.
	class Edge < Struct.new(:commands, :leftFill, :rightFill)
		
		# Load from XFL `Edge` element.
		def self.fromXFL(edgeElem, fills)
			edge = Edge.new( edgeData2arr( edgeElem['edges'] ) )
			edge.leftFill  = fills[ edgeElem['fillStyle0'].to_i - 1 ] if edgeElem['fillStyle0']
			edge.rightFill = fills[ edgeElem['fillStyle1'].to_i - 1 ] if edgeElem['fillStyle1']
			edge.simplify!
		end
		
		# Starting point of the edge.
		def startPoint
			commands[0].endPoint
		end
		
		# Ending point of the edge.
		def endPoint
			commands[-1].endPoint
		end
		
		
		# Converts 32-bit fixed-point number from hexadecimal string to its corresponding number.
		# FIXME: Account for incomplete fractional bytes.
		def self.hexToNum(hexstr)
			num = hexstr.gsub('.','').hex
			num = (num >= '80000000'.hex)  ?  -('FFFFFFFF'.hex - num + 1)  :  num
			num.to_f / 256
		end
		
		
		# Read XFL edge data string into an array of Commands (returned).
		# Numbers are decoded as floating point values with correct scale.
		# TODO: Hmm... This could be a constructor as well...
		def self.edgeData2arr(edgeData)
			edgeData.scan( /([!|\/\[])([^!|\/\[]+)/ ).map do |opcode,params|
				numbers = params.scan( /(#?)(\S+)\s*/ ).map do |prefix,number|
					prefix == '#'  ?  hexToNum(number)  :  number.to_f / 20
				end
				case opcode
				 when '!' then Command::MoveTo.new(*numbers)
				 when '|' then Command::LineTo.new(*numbers)
				 when '[' then Command::CurveTo.new(*numbers)
				end
			end
		end
		
		
		# Simplify the edge commands:
		# If a `moveTo` command has the same coordinates as the endpoint of the preceding command,
		# it is redundant and can be safely removed.
		def simplify!
			commands.each_with_index do |cmd,index|
				next unless cmd.is_a?(Command::MoveTo) and index > 0
				prevCmd = commands[index-1]
				commands.delete_at(index) if prevCmd.endPoint == cmd.endPoint
			end
			self
		end
		
		
		# Generate commands for an edge with its direction reversed.
		def reverse
			revEdge = [ Command::MoveTo.new(endPoint) ]
			revCmds = commands.reverse  # reverses an array of commands.
			revCmds[0..-2].each_with_index do |cmd,index|
				newCmd = cmd.dup
				newCmd.endPoint = revCmds[index+1].endPoint
				revEdge << newCmd
			end
			Edge.new(revEdge, rightFill, leftFill)  # We also need to flip the fill styles.
		end
		
		
		# Append the given edge at the end of the current edge.
		# We assume that the other one begins when the current one ends.
		# We also retain the current edge's fill styles. The other edge's fill styles will be lost.
		def append(otherEdge)
			result = self.dup
			result.commands += otherEdge.commands[1..-1]
			result
		end
		
		
		def closed?
			self.endPoint == self.startPoint
		end
		
		
		private_class_method :hexToNum, :edgeData2arr
		
	end  # class Edge
	
end  # module XFL