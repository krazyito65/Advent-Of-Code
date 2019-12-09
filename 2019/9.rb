# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
require_relative '5.rb'

d5p2 = Day5.new([2])
d5p1 = Day5.new([1])

puzzle_input = get_array(File.absolute_path(__FILE__)).map!(&:to_i)

start = Time.now
d5p1.parse_opcode(puzzle_input.dup)
finish = Time.now
diff1 = finish - start

start = Time.now
d5p2.parse_opcode(puzzle_input.dup)
finish = Time.now
diff2 = finish - start

puts 'Day9:'
puts "  part1: #{diff1}"
puts "  part2: #{diff2}"
