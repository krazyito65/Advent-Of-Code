# frozen_string_literal: true

require_relative 'util/shared_functions.rb'

# Day1 functions
class Day1
  def fuel_required(mass)
    total_fuel = (mass / 3).floor - 2
    return 0 if total_fuel.negative?

    total_fuel += fuel_required(total_fuel)
    return total_fuel
  end

  def total_fuel
    input = get_list(File.absolute_path(__FILE__))
    total_fuel = 0

    input.each do |mass|
      total_fuel += fuel_required(mass.to_i)
    end

    return total_fuel
  end
end

d = Day1.new

puts "#{File.basename(__FILE__)}: #{d.total_fuel}"
