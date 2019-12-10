# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
require 'pp'

input = get_list(File.absolute_path(__FILE__))
asteroids = []

# populate array of map
input.each_with_index do |ar, index|
  input[index] = ar.chars
  # puts input[index].to_s
end

# populate an array of asteroids.
input.each_with_index do |y_arr, y|
  y_arr.each_with_index do |_, x|
    asteroids.push([x, y]) if input[y][x].eql?('#')
  end
end

pp asteroids

def get_slopes_of_asteroids(asteroids, slopes = {})
  # get the first asteroid in the array
  x1 = asteroids[0][0]
  y1 = asteroids[0][1]

  asteroids.shift # remove the first element so we can pass the rest of the elements recursivly
  asteroids.each do |coord|
    # get the 2nd asteroid in the list
    x2 = coord[0]
    y2 = coord[1]
    slope = slope(x1, y1, x2, y2) # Math.atan2(x1 - x2, y1 - y2)

    # Add slope to the hash, create blank array first if its nil.
    (slopes["#{x1},#{y1}"] ||= []) << slope
    (slopes["#{x2},#{y2}"] ||= []) << slope

    # This creates a hash of points, each with an array of slopes.
    # Hash gaurentees that we only have one array of slopes per asteroid
    # later on, we take the uniq count of slopes.

    puts "#{x1},#{y1} -> #{x2},#{y2}"
  end
  puts '========================'

  # stop recursing if we have no more asteroids
  get_slopes_of_asteroids(asteroids, slopes) unless asteroids.empty?
  return slopes
end

# determine the slope between two points.
def slope(x1, y1, x2, y2)
  # 3,4 ------ 2, 2 and 1, 0
  # puts Math.atan2(4 - 2, 3 - 2) => 1.1071487177940904
  # puts Math.atan2(4 - 0, 3 - 1) => 1.1071487177940904
  return Math.atan2(x1 - x2, y1 - y2)
end

# puts asteroids.to_s
point_slopes = get_slopes_of_asteroids(asteroids)
# pp point_slopes

# map the points to the count of uniq slopes, and then find the slope with the max amount of points
a = point_slopes.map { |point, slopes| [point, slopes.uniq.count] }.to_h.max_by { |_, v| v }
puts a.to_s
