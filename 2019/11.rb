# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
require_relative '5.rb'
require 'pp'

# hull painting robot.
class Robot
  def paint(color)
    return color.eql?(0) ? ' ' : '#'
  end

  def turn(direction)
    return direction.eql?(0) ? -90 : 90
  end
end

d5 = Day5.new([0])

puzzle_input = get_array(File.absolute_path(__FILE__)).map!(&:to_i)

d5.parse_opcode(puzzle_input.dup)
