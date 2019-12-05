# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
# require_relative '2.rb'

if ARGV.empty?
  puts 'Too few arguments, please provide an input'
  exit
end

# overload new method to string class to see if its a number.
class String
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end

unless ARGV[0].numeric?
  puts 'Input is not a number.'
  exit
end

# redefine day 2
class Day5
  def parse_opcode(input)
    index = 0
    while 1.positive?

      instruction = input[index].to_s.each_char.map(&:to_i)
      opcode = instruction.pop(2).join.to_i
      break if opcode.equal?(99)

      # Modes:
      mode1 = instruction.pop || 0
      mode2 = instruction.pop || 0
      # mode3 = instruction.pop # this will always refer to a position to WRITE to. (should always be 0)

      pos1 = input[index + 1]
      pos2 = input[index + 2]
      pos3 = input[index + 3] # this will always refer to a position to WRITE to.

      val1 = get_vals(pos1, mode1, input) # get the val incase we need to print it
      val2 = get_vals(pos2, mode2, input)
      val3, increment = get_val3(opcode, val1, val2)

      input[pos1] = ARGV[0].to_i if opcode.eql?(3) # input is 1.  (this saves me from actually inputting it manually)
      puts val1 if opcode.eql?(4) # output the value
      index = val1.nonzero? ? val2 : index + 3 if opcode.eql?(5) # output the value
      index = val1.zero? ? val2 : index + 3 if opcode.eql?(6) # output the value
      input[pos3] = val1 < val2 ? 1 : 0 if opcode.eql?(7)
      input[pos3] = val1.eql?(val2) ? 1 : 0 if opcode.eql?(8)

      index += increment
      next if opcode > 2 # if its 3 or 4, val3 is worthless

      input[pos3] = val3
    end
  end

  def get_vals(position_value, mode, input)
    # puts "get vals: #{position_value} - #{mode}"
    case mode
    when 0
      return input[position_value]
    when 1
      return position_value
    end
  end

  def get_val3(opcode, val1, val2)
    val3 = 0
    case opcode
    when 1
      val3 = val1 + val2
      increment = 4
    when 2
      val3 = val1 * val2
      increment = 4
    when 3
      increment = 2
    when 4
      increment = 2
    when 5
      increment = 0
    when 6
      increment = 0
    when 7
      increment = 4
    when 8
      increment = 4
    else
      puts "[ERROR] incorrect opcode detected: #{opcode}"
      exit 1
    end
    return val3, increment
  end
end

input = get_array(File.absolute_path(__FILE__)).map!(&:to_i)

d = Day5.new

d.parse_opcode(input)
