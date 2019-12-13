# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
require 'pp'

class Hash
  def compact
    delete_if { |k, v| v.nil? || v.empty? }
  end
end

def get_angle(dx, dy)
  a = Math.atan2(dx, -dy) * (180 / Math::PI)
  a += 360 if a.negative?
  return a
end

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
    # input[y][x] because of how the array is mapped compared to how its shown
  end
end

# pp asteroids

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
    slope2 = slope(x2, y2, x1, y1) # do the reverse of the above.

    # Add arctangent to the hash, create blank array first if its nil.
    (slopes["#{x1},#{y1}"] ||= []) << slope
    (slopes["#{x2},#{y2}"] ||= []) << slope2 # save the 2nd arctangent with the 2nd point.
    # This creates a hash of points, each with an array of arctangents.
    # Hash gaurentees that we only have one array of arctangents per asteroid
    # later on, we take the uniq count of slopes.

    # puts "#{x1},#{y1} -> #{x2},#{y2}"
  end
  # puts '========================'

  # stop recursing if we have no more asteroids
  get_slopes_of_asteroids(asteroids, slopes) unless asteroids.empty?
  return slopes
end

def get_asteroid_angles(asteroids, station_location, angles = {})
  asteroids.shift if asteroids[0].eql?(station_location) # skip the asteroid the station is on.

  dx = asteroids[0][0] - station_location[0]
  dy = asteroids[0][1] - station_location[1]

  angle = get_angle(dx, dy)

  # angles = { angle => angles[angle] || [] }

  (angles[angle] ||= []) << asteroids[0]
  # puts asteroids[0].to_s
  # angles[angle] += asteroids[0]

  asteroids.shift # remove the first element so we can pass the rest of the elements recursivly
  get_asteroid_angles(asteroids, station_location, angles) unless asteroids.empty?
  return angles
end

# determine the slope between two points.
def slope(x1, y1, x2, y2)
  # 3,4 ------ 2, 2 and 1, 0
  # puts Math.atan2(4 - 2, 3 - 2) => 1.1071487177940904
  # puts Math.atan2(4 - 0, 3 - 1) => 1.1071487177940904
  return Math.atan2(x1 - x2, y1 - y2)
end

def distance(station_x, station_y, asteriod_x, asteroid_y)
  return Math.sqrt((asteriod_x - station_x)**2 + (asteroid_y - station_y)**2)
end

# puts asteroids.to_s
point_slopes = get_slopes_of_asteroids(asteroids.dup)

# sort the arctangents
point_slopes.map { |_, arctangents| arctangents.sort! }

# pp point_slopes

# map the points to the count of uniq slopes, and then find the slope with the max amount of points
a = point_slopes.map { |point, slopes| [point, slopes.uniq.count] }.to_h.max_by { |_, v| v }

# b = {}
# # iterate over the array, counting duplicate entries
# point_slopes.each do |k, arr|
#   b[k] = {} if b[k].nil?
#   # puts k, arr.to_s
#   arr.each do |slope|
#     b[k][slope] = 0 if b[k][slope].nil?
#     b[k][slope] += 1
#   end
# end

# pp b

# part 1
puts 'Day10'
puts "part1: #{a}"


# part 2
station_location = [a[0].split(/,/)[0].to_i, a[0].split(/,/)[1].to_i]
# puts "station_location: #{station_location}"
starting_point = [station_location[0], station_location[1] - 1]

# puts "starting point: #{starting_point}"

asteroid_angles = get_asteroid_angles(asteroids, station_location).sort.to_h

# pp asteroid_angles

asteroid_count = 0
until asteroid_angles.empty?
  asteroid_angles.each do |angle, ast|
    # puts "#{angle} => #{ast[0]}"
    closest_point = ast.map { |point|
      distance(starting_point[0], starting_point[1], point[0], point[1])
    }.each_with_index.min[1]
    asteroid_count += 1
    # puts "#{asteroid_count}: #{ast[closest_point]}"
    asteroid_angles[angle] -= [ast[closest_point]]
    if asteroid_count.eql?(200)
      puts "part2: #{ast[closest_point]}"
      break
    end
  end
  asteroid_angles.compact # only needed if we don't break so its not infinite.
  # puts '============'
end


# puts asteroids.to_s
