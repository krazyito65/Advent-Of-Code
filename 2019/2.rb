# frozen_string_literal: true

require_relative 'util/shared_functions.rb'

# Day2 functions
class Day2
  def parse_opcode(input)
    input.each_with_index do |opcode, index|
      next unless (index % 4).equal?(0)
      break if opcode.equal?(99)

      val1, val2 = get_vals(input, index)
      val3 = get_val3(opcode, val1, val2, index)

      pos3 = input[index + 3]
      input[pos3] = val3
    end
    return input
  end

  def get_vals(input, index)
    pos1 = input[index + 1]
    pos2 = input[index + 2]

    val1 = input[pos1]
    val2 = input[pos2]

    return val1, val2
  end

  def get_val3(opcode, val1, val2, index)
    case opcode
    when 1
      val3 = val1 + val2
    when 2
      val3 = val1 * val2
    else
      puts "[ERROR] incorrect opcode detected: #{opcode} at position #{index}"
      exit 1
    end
    return val3
  end

  def find_input(input, answer)
    output = 0
    noun = -1
    verb = 0
    until output.eql?(answer)
      if noun.eql?(99)
        noun = -1
        verb += 1
      end
      noun += 1
      input[0] = 1
      input[1] = noun
      input[2] = verb
      output = parse_opcode(input.dup)[0]
    end
    return input[1], input[2]
  end
end

d = Day2.new

# puts d.parse_opcode([1, 0, 0, 0, 99])
input = get_array(File.absolute_path(__FILE__)).map!(&:to_i)
puts "#{File.basename(__FILE__)}: #{d.parse_opcode(input.dup)}"
puts "#{File.basename(__FILE__)} part2: #{d.find_input(input.dup, 19_690_720)}"
