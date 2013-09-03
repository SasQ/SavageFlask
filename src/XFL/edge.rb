require 'xml'
require_relative 'commands'   # available since Ruby 1.9.2

module XFL
	
	
	# Handling edges.
	module Edge
		#extend Command  # Allows using `Command`'s functions without the need for full qualification.
		#private_class_method *Command.public_instance_methods  # Makes this implementation detail invisible to the outside world.
		
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
		
		
		# Read XFL edge data string into an array of Commands.
		# Numbers are decoded as floating point values with correct scale.
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
		
		
		# Simplify the edge data:
		# If a `moveTo` command has the same coordinates as the endpoint of the preceding command,
		# it is redundant and can be safely removed.
		def self.simplifyPath!(edgeArr)
			edgeArr.each_with_index do |cmd,index|
				next unless cmd.is_a?(Command::MoveTo) or index > 0
				prevCmd = edgeArr[index-1]
				edgeArr.delete_at(index) if prevCmd.endPoint == cmd.endPoint
			end
		end
		
		
		private_class_method :hexToNum, :opStrToSym
		
	end  # module Edge
	
end  # module XFL