# frozen_string_literal: true

require_relative 'util/shared_functions.rb'

input = get_string(File.absolute_path(__FILE__))

input = format('%05<n>d', n: input).scan(/\d/).map!(&:to_i)
layers = []
dimensions = 25 * 6

layers.push(input.shift(dimensions)) until input.empty?

zeros = []
image = Array.new(dimensions, 2)

layers.each do |layer|
  zeros.push(layer.count(0))
  layer.each_with_index do |pixel, index|
    next unless image[index].eql?(2)

    image[index] = ' ' if pixel.eql?(0)
    image[index] = '#' if pixel.eql?(1)
  end
end

least_zeros = zeros.each_with_index.min.last

puts "day 8 part1: #{layers[least_zeros].count(1) * layers[least_zeros].count(2)}"
print 'Day2:'
image.each_with_index do |pixel, index|
  puts "\n" if (index % 25).eql?(0)
  print pixel
end
puts ''
