# frozen_string_literal: true

require_relative 'util/shared_functions.rb'
require_relative '5.rb'

# day 7
class Amp
  def initialize(input, phase_setting = nil)
    # puts "INITING AMP: #{[phase_setting, input]}"
    @input = input
    @phase_setting = phase_setting

    @puzzle_input = get_array(File.absolute_path(__FILE__)).map!(&:to_i)
  end

  def parse_amp_code
    # puts "stuff: #{[@phase_setting, @input]}"

    d5 = Day5.new([@phase_setting, @input])

    # puts "input: #{input}"

    return d5.parse_opcode(@puzzle_input.dup)
  end
end

def generate_signals(feedback_loop = false)
  signals = []
  min_signal = feedback_loop ? 56_789 : 1_234
  max_signal = feedback_loop ? 98_765 : 43_210
  puts "#{min_signal} - #{max_signal}"
  (min_signal..max_signal).each do |signal|
    signal = format('%05<n>d', n: signal).scan(/\d/).map!(&:to_i)
    next if (signal & (5..9).to_a).any? && !feedback_loop
    next if (signal & (0..4).to_a).any? && feedback_loop

    next unless signal.uniq.length.eql?(signal.length) # skip if there are any duplicate numbers in the array

    signals.push(signal)
  end
  # puts "signals.length: #{signals.length}"
  return signals
end

def find_largest_signal(feedback_loop = false)
  largest_signal = 0

  generate_signals(feedback_loop).each do |phase_settings|
    user_input = 0
    puts ''
    puts "phase setting #{phase_settings}"
    # puts ""
    phase_settings.each do |setting|
      puts ''
      puts "setting #{setting}"
      # puts ""
      user_input = Amp.new(user_input, setting).parse_amp_code
      # puts "user_input #{user_input}"
      # puts ""
    end

    puts ''
    # memory[i]["output"] = solve(memory[i]["data"], memory[i]["parameter_input"]
    # memory[i]["pos"] = memory[i]["output"]
    # memory[i]["input_number"] =  memory[i]["pos"]
    # end = memory[i]["input_number"])

    # (0..4).each do |_|
    #   (0..4).each do |_|
    #     user_input = Amp.new(0, user_input).parse_amp_code
    #   end
    # end

    largest_signal = user_input > largest_signal ? user_input : largest_signal
    # print "largest_signal #{largest_signal}"
    # puts ""
    # exit
  end
  return largest_signal
end

# puts "part1: #{find_largest_signal}"
puts "part2: #{find_largest_signal(true)}"
# a = Amp.new(3, 0)
