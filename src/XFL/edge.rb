require 'xml'

module XFL
	
	# Handling vector drawing commands.
	# TODO: This definitely should be converted into a class.
	module Command
		extend self
		
		
		# Return the command's opcode.
		def cmdOp(cmd)
			return cmd[0]  # First item is the opcode.
		end
		
		
		# Return the command's destination point.
		def cmdTo(cmd)
			return cmd[-2..-1]  # Last two numbers are always the endpoint.
		end
		
		# TODO: If we make command to be a class, the above functions can be then turned into its methods.
		
		
	end  # module Command
	
	
	# Handling edges.
	module Edge
		extend Command  # Allows using `Command`'s functions without the need for full qualification.
		private_class_method *Command.public_instance_methods  # Makes this implementation detail invisible to the outside world.
		
		# Convert XFL opcodes to human-readable symbols.
		def self.opStrToSym(opcodeStr)
			return { '!' => :moveTo, '|' => :lineTo, '/' => :lineTo, '[' => :curveTo, '(' => :cubicTo }[opcodeStr]
		end
		
		
		# Converts 32-bit fixed-point number from hexadecimal string to its corresponding number.
		# TODO: Account for incomplete fractional bytes.
		def self.hexToNum(hexstr)
			num = hexstr.gsub('.','').hex
			num = (num >= '80000000'.hex)  ?  -('FFFFFFFF'.hex - num + 1)  :  num
			num.to_f / 256
		end
		
		
		# Read XFL edge data string into a nested array.
		# Numbers are decoded as floating point values with correct scale.
		def self.edgeData2arr(edgeData)
			edgeData.scan( /([!|\/\[])([^!|\/\[]+)/ ).map do |opcode,params|
				numbers = params.scan( /(#?)(\S+)\s*/ ).map do |prefix,number|
					prefix == '#'  ?  hexToNum(number)  :  number.to_f / 20
				end
				[ opStrToSym(opcode), *numbers ]
			end
		end
		
		
		# Simplify the edge data:
		# If a `moveTo` command has the same coordinates as the endpoint of the preceding command,
		# it is redundant and can be safely removed.
		def self.simplifyPath!(edgeArr)
			edgeArr.each_with_index do |cmd,index|
				next unless cmdOp(cmd) == :moveTo or index > 0
				prevCmd = edgeArr[index-1]
				edgeArr.delete_at(index) if cmdTo(prevCmd) == cmdTo(cmd)
			end
		end
		
		
		private_class_method :hexToNum, :opStrToSym
		
	end  # module Edge


end  # module XFL