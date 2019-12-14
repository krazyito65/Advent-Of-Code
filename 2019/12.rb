# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
require 'pp'

# Jupiters Moons
class Moons
  # shorthand for set/get methods
  attr_accessor :name, :x, :y, :z, :pos, :vel, :inital_state
  attr_accessor :time_step_x, :time_step_y, :time_step_z, :time_step

  @@all = []

  def initialize(name, x, y, z)
    @x = x
    @y = y
    @z = z
    @name = name
    @vel = [0, 0, 0]
    @time_step = 0
    @time_step_x = 0
    @time_step_y = 0
    @time_step_z = 0
    update_positions
    @inital_state = [x, y, z]
    @@all << self
  end

  def update_positions
    @pos = [x, y, z]
  end

  def self.all
    return @@all
  end

  def self.remove_all
    @@all = []
  end

  def self.increment_time(all_moons = @@all)
    # puts 'incrementing time'
    # for each moon
    all_moons.each_with_index do |current_moon, index|
      # compare with every other moon
      (index + 1..all_moons.length - 1).each do |jindex|
        next_moon = all_moons[jindex]
        current_moon.apply_gravity(current_moon, next_moon) # apply gravity between these 2 moons.
        # puts "#{current_moon.name} + #{next_moon.name}"
      end
    end

    all_moons.each(&:apply_velocity)
  end

  def self.increment_time_x(all_moons = @@all)
    # puts 'incrementing time'
    # for each moon
    all_moons.each_with_index do |current_moon, index|
      # compare with every other moon
      (index + 1..all_moons.length - 1).each do |jindex|
        next_moon = all_moons[jindex]
        current_moon.update_x_velocity(current_moon, next_moon) # apply gravity between these 2 moons.
        # puts "#{current_moon.name} + #{next_moon.name}"
      end
    end

    all_moons.each(&:apply_x_velocity)
  end

  def self.increment_time_y(all_moons = @@all)
    # puts 'incrementing time'
    # for each moon
    all_moons.each_with_index do |current_moon, index|
      # compare with every other moon
      (index + 1..all_moons.length - 1).each do |jindex|
        next_moon = all_moons[jindex]
        current_moon.update_y_velocity(current_moon, next_moon) # apply gravity between these 2 moons.
        # puts "#{current_moon.name} + #{next_moon.name}"
      end
    end

    all_moons.each(&:apply_y_velocity)
  end

  def self.increment_time_z(all_moons = @@all)
    # puts 'incrementing time'
    # for each moon
    all_moons.each_with_index do |current_moon, index|
      # compare with every other moon
      (index + 1..all_moons.length - 1).each do |jindex|
        next_moon = all_moons[jindex]
        current_moon.update_z_velocity(current_moon, next_moon) # apply gravity between these 2 moons.
        # puts "#{current_moon.name} + #{next_moon.name}"
      end
    end

    all_moons.each(&:apply_z_velocity)
  end

  def apply_gravity(moon1, moon2)
    # puts "applying gravity between #{moon1.name} and #{moon2.name}"
    update_x_velocity(moon1, moon2)
    update_y_velocity(moon1, moon2)
    update_z_velocity(moon1, moon2)
  end

  def update_x_velocity(moon1, moon2)
    if moon1.x < moon2.x
      # puts "#{moon1.name}.x < #{moon2.name}.x"
      moon1.vel[0] += 1
      moon2.vel[0] -= 1
    elsif moon1.x > moon2.x
      # puts "#{moon1.name}.x > #{moon2.name}.x"
      moon2.vel[0] += 1
      moon1.vel[0] -= 1
    end
  end

  def update_y_velocity(moon1, moon2)
    if moon1.y < moon2.y
      # puts "#{moon1.name}.y < #{moon2.name}.y"
      moon1.vel[1] += 1
      moon2.vel[1] -= 1
    elsif moon1.y > moon2.y
      # puts "#{moon1.name}.y > #{moon2.name}.y"
      moon2.vel[1] += 1
      moon1.vel[1] -= 1
    end
  end

  def update_z_velocity(moon1, moon2)
    if moon1.z < moon2.z
      # puts "#{moon1.name}.z < #{moon2.name}.z"
      moon1.vel[2] += 1
      moon2.vel[2] -= 1
    elsif moon1.z > moon2.z
      # puts "#{moon1.name}.z > #{moon2.name}.z"
      moon2.vel[2] += 1
      moon1.vel[2] -= 1
    end
  end

  def apply_velocity
    # puts 'apply velocity'
    # puts "#{@x.class} += #{@vel[0].class}"
    @x += @vel[0]
    @y += @vel[1]
    @z += @vel[2]
    update_positions
    @time_step += 1
  end

  def apply_x_velocity
    @x += @vel[0]
    update_positions
    @time_step_x += 1
  end

  def apply_y_velocity
    @y += @vel[1]
    update_positions
    @time_step_y += 1
  end

  def apply_z_velocity
    @z += @vel[2]
    update_positions
    @time_step_z += 1
  end

  def calulate_potential_energy
    sum = 0
    @pos.each do |num|
      sum += num.abs
    end
    return sum
  end

  def calulate_kinetic_energy
    sum = 0
    @vel.each do |num|
      sum += num.abs
    end
    return sum
  end

  def self.calulate_total_energy(moon)
    return moon.calulate_potential_energy * moon.calulate_kinetic_energy
  end
end

def input_moons(input)
  names = %w[Io Europa Ganymede Callisto]

  input.each_with_index do |coord, index|
    x = coord.match(/x=(-?\d+)/)[1].to_i
    y = coord.match(/y=(-?\d+)/)[1].to_i
    z = coord.match(/z=(-?\d+)/)[1].to_i
    # puts "Moons.new(#{names[index]}, #{x}, #{y}, #{z})"
    Moons.new(names[index], x, y, z)
  end
end

input = get_list(File.absolute_path(__FILE__))

# pp input
input_moons(input)

# Io = Moons.new('Io', -1, 0, 2)
# Europa = Moons.new('Europa', 2, -10, -7)
# Ganymede = Moons.new('Ganymede', 4, -8, 8)
# Callisto = Moons.new('Callisto', 3, 5, -1)

# testing..

# puts '===============TIME: 0==============='
# Moons.all.each do |moon|
#   puts "#{moon.pos}, #{moon.vel}"
# end
init_state = 0

## part1
loop.with_index do |_, time|
  # puts "===============TIME: #{time}==============="
  total_energy = 0
  init_state = 0
  Moons.increment_time
  Moons.all.each do |moon|
    moon_energy = Moons.calulate_total_energy(moon)
    total_energy += moon_energy
    # puts "#{moon.pos}, #{moon.vel}, #{moon_energy}" if moon.time_step.eql?(1)
    # next unless moon.vel.eql?([0, 0, 0]) && moon.pos.eql?(moon.inital_state)

    # init_state += 1
    # next unless init_state.eql?(4)

    # puts moon.time_step
    # b = true
    # moon.inital_state
  end

  puts "Total Energy at step #{time}: #{total_energy}" if time.eql?(1000)
  break if time.eql?(1000)
end

Moons.remove_all

input_moons(input)

x_steps = 0
y_steps = 0
z_steps = 0


## get x steps
loop.with_index do |_, time|
  # puts "===============TIME: #{time}==============="
  init_state = 0
  Moons.increment_time_x
  break unless Moons.all.each do |moon|
    # puts "#{moon.pos}, #{moon.vel}"
    next unless moon.vel[0].eql?(0) && moon.pos[0].eql?(moon.inital_state[0])

    init_state += 1
    next unless init_state.eql?(4)

    x_steps = moon.time_step_x
    puts "initial x: #{moon.pos[0]}, steps: #{moon.time_step_x}"
    break
  end
  # break
end

## get y steps
loop.with_index do |_, time|
  # puts "===============TIME: #{time}==============="
  init_state = 0
  Moons.increment_time_y
  break unless Moons.all.each do |moon|
    # puts "#{moon.pos}, #{moon.vel}"
    next unless moon.vel[1].eql?(0) && moon.pos[1].eql?(moon.inital_state[1])

    init_state += 1
    next unless init_state.eql?(4)

    y_steps = moon.time_step_y
    puts "initial y: #{moon.pos[1]}, steps: #{moon.time_step_y}"
    break
  end
  # break
end

## get z steps
loop.with_index do |_, time|
  # puts "===============TIME: #{time}==============="
  init_state = 0
  Moons.increment_time_z
  break unless Moons.all.each do |moon|
    # puts "#{moon.pos}, #{moon.vel}"
    next unless moon.vel[2].eql?(0) && moon.pos[2].eql?(moon.inital_state[2])

    init_state += 1
    next unless init_state.eql?(4)

    z_steps = moon.time_step_z
    puts "initial z: #{moon.pos[2]}, steps: #{moon.time_step_z}"
    break
  end
  # break
end

puts "LCM: #{[x_steps,y_steps,z_steps].reduce(1, :lcm)}"
