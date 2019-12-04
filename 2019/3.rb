# frozen_string_literal: true

require_relative 'util/shared_functions.rb'

# Coordinates
X = 0
Y = 1

class Day3
  def get_points(line)
    line1 = [[0, 0]]

    line.each do |direction|
      direction = direction.split(/(\d+)/)
      amount = direction[1].to_i

      # R75,D30,R83,U83,L12,D49,R71,U7,L72
      (1..amount).each do |_|
        last_x = line1[-1][X]
        last_y = line1[-1][Y]

        case direction[0]
        when 'R'
          line1.push([last_x + 1, last_y])
        when 'L'
          line1.push([last_x - 1, last_y])
        when 'U'
          line1.push([last_x, last_y + 1])
        when 'D'
          line1.push([last_x, last_y - 1])
        end
      end
    end
    return line1
  end
end

def get_intersections(first_line_points, second_line_points)
  return first_line_points & second_line_points
end

def get_shortest_path(intersections)
  paths = []
  intersections.each do |point|
    paths.push(point[0].abs + point[1].abs) unless point[0].eql?(0) && point[1].eql?(0)
  end
  return paths.min
end

d = Day3.new
input = get_list(File.absolute_path(__FILE__))
input.map! { |line| line.split(',') }

first_line_points = d.get_points(input[0])
second_line_points = d.get_points(input[1])

intersections = get_intersections(first_line_points, second_line_points).drop(1)

puts "#{File.basename(__FILE__)}: #{get_shortest_path(intersections)}"

least_steps = nil
intersections.each do |intersection|
  one = first_line_points.index(intersection)
  two = second_line_points.index(intersection)
  steps = one + two
  least_steps = least_steps.nil? || (steps < least_steps) ? steps : least_steps
end

puts "#{File.basename(__FILE__)} part2: #{least_steps}"
