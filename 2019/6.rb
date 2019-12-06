# frozen_string_literal: true

require_relative 'util/shared_functions.rb'

orbits = get_list(File.absolute_path(__FILE__))

def build_orbit_hash(orbits)
  full_orbits = {}
  masses = []
  orbits.each do |orbit|
    objects = orbit.split(')')
    center = objects[0]
    orb = objects[1]
    masses.push(center, orb).uniq!
    full_orbits[center] = (full_orbits[center] || []).push(orb)
  end

  return full_orbits, masses
end

def count_orbits(orbit_map, mass, count = 0, set = [mass])
  key = orbit_map.select { |_, v| v.include?(mass) }.keys[0]
  set += [key]
  return count, set if key.nil?

  count += 1
  count_orbits(orbit_map, key, count, set)
end

def distance(a, b)
  (a + b) - (a & b) # get the difference of the 2 sets (opposite of intersection)
end

part1 = 0
start = Time.now
full_orbits, masses = build_orbit_hash(orbits)
masses.each do |mass|
  count, = count_orbits(full_orbits, mass)
  part1 += count
end
finish = Time.now
diff = finish - start

puts "Day6 part1 Time: #{diff}"
puts "          part1: #{part1}"

start = Time.now
me = full_orbits.select { |_, v| v.include?('YOU') }.keys[0]
santa = full_orbits.select { |_, v| v.include?('SAN') }.keys[0]
_, me_set = count_orbits(full_orbits, me)
_, santa_set = count_orbits(full_orbits, santa)
part2 = distance(me_set, santa_set).length
finish = Time.now
diff = finish - start

puts "Day6 part2 Time: #{diff}"
puts "          part1: #{part2}"
