# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
# require_relative '2.rb'

if ARGV.empty? && $PROGRAM_NAME.eql?(__FILE__)
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

if $PROGRAM_NAME.eql?(__FILE__) && !ARGV[0].numeric?
  puts 'Input is not a number.'
  exit
end

# redefine day 2
class Day5
  def initialize(user_input = [])
    # puts "INITTING DAY5 #{user_input}"
    @user_input = user_input
  end

  def parse_opcode(input)
    # phase setting is an array with [phase_setting, user_input]
    index = 0
    input_count = 0
    last_four = 0
    relative_base = 0
    while 1.positive?
      # puts "================#{index}(#{input[index]})====================="
      instruction = input[index].to_s.each_char.map(&:to_i)
      opcode = instruction.pop(2).join.to_i
      return last_four if opcode.equal?(99)

      # Modes:
      mode1 = instruction.pop || 0
      mode2 = instruction.pop || 0
      mode3 = instruction.pop || 0 # this will always refer to a position to WRITE to. (should always be 0)

      # puts "modes: #{mode1}, #{mode2}, #{mode3}"
      pos1 = input[index + 1]
      pos2 = input[index + 2]
      pos3 = input[index + 3] # this will always refer to a position to WRITE to.

      val1 = get_vals(pos1, mode1, input, relative_base) # get the val incase we need to print it
      val2 = get_vals(pos2, mode2, input, relative_base)
      # puts "val1: #{val1}, val2: #{val2}, opcode: #{opcode}"

      val3, increment = get_val3(opcode, val1, val2)

      if opcode.eql?(3) # input is 1.  (this saves me from actually inputting it manually)
        # puts "opcode 3: setting input[#{pos1}] = #{@user_input}[#{input_count}] (#{@user_input[input_count]})"
        # puts "using last printed number: #{last_four}" if @user_input[input_count].nil?
        # puts "before: input[#{(mode1.eql?(2) ? pos1 + relative_base : pos1)}] = #{input[(mode1.eql?(2) ? pos1 + relative_base : pos1)]}"
        input[(mode1.eql?(2) ? pos1 + relative_base : pos1)] = @user_input[input_count] || last_four
        # puts "opcode 3: #{(mode1.eql?(2) ? pos1 + relative_base : pos1)} = #{@user_input[input_count]}"
        # puts "after: input[#{(mode1.eql?(2) ? pos1 + relative_base : pos1)}] = #{input[(mode1.eql?(2) ? pos1 + relative_base : pos1)]}"
        input_count += 1
      end
      if opcode.eql?(4) # output the value
        last_four = val1
        puts val1
      end

      index = val1.nonzero? ? val2 : index + 3 if opcode.eql?(5) # output the value
      index = val1.zero? ? val2 : index + 3 if opcode.eql?(6) # output the value
      if opcode.eql?(7)
        input[(mode3.eql?(2) ? pos3 + relative_base : pos3)] = val1 < val2 ? 1 : 0
      end
      if opcode.eql?(8)
        input[(mode3.eql?(2) ? pos3 + relative_base : pos3)] = val1.eql?(val2) ? 1 : 0
      end
      relative_base += val1 if opcode.eql?(9)
      # puts "relative_base: #{relative_base}"

      index += increment
      next if opcode > 2 # if its 3 or 4, val3 is worthless

      input[(mode3.eql?(2) ? pos3 + relative_base : pos3)] = val3
    end
    return last_four
  end

  def get_vals(position_value, mode, input, relative_base)
    # puts "get vals: #{position_value} - #{mode}"
    case mode
    when 0
      # puts "input: #{input}"
      # puts "position mode: return #{input[position_value]}"
      return input[position_value]
    when 1
      # puts "immediate mode: return #{position_value}"
      return position_value
    when 2
      # relative mode
      # puts "input: #{input}"
      # puts "relative mode: returning input[#{relative_base} + #{position_value}] = #{input[relative_base + position_value]}"
      return input[relative_base + position_value]
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
    when 9
      increment = 2
    else
      puts "[ERROR] incorrect opcode detected: #{opcode}"
      exit 1
    end
    return val3, increment
  end
end

# input = get_array(File.absolute_path(__FILE__)).map!(&:to_i)

# d = Day5.new([ARGV[0].to_i])
# d = Day5.new([6, 4686].reject(&:nil?))
# puts d.parse_opcode(input)
