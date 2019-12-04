# frozen_string_literal: true

require_relative 'util/shared_functions.rb'

# overload int class to add function
class Integer
  def split_digits
    return [0] if zero?

    res = []
    quotient = self.abs # take care of negative integers
    until quotient.zero?
      quotient, modulus = quotient.divmod(10) # one go!
      res.unshift(modulus) # put the new value on the first place, shifting all other values
    end
    res # done
  end
end

### RLE
def rle_encode(input)
  input
    .chars
    .chunk { |c| c }
    .collect { |k, v| { k => v.length } }.reduce({}, :merge)
end

def rle_double?(rle)
  return rle.any? { |_, v| v >= 2 }
end

def rle_has_single_double?(rle)
  return rle.any? { |_, v| v == 2 }
end

def throw_away_part1_rle(input)
  rle = rle_encode(input)
  return true unless ascending_order?(input) && rle_double?(rle)
end

#######

def double_and_not_triple?(input)
  (0..9).each do |num|
    return true if input.to_s.include?(num.to_s * 2) && !input.to_s.include?(num.to_s * 3)
  end
  return false
end

def ascending_order?(input)
  digits = input.to_i.split_digits
  return digits.eql?(digits.sort)
end

def double_digits?(input)
  return input.match?(/([0-9])\1{1}/)
end

def throw_away_part1?(input)
  return true unless ascending_order?(input) && double_digits?(input)
end

range = get_list(File.absolute_path(__FILE__))
count = 0
count2 = 0

# base
start = Time.now
(range[0].to_i..range[1].to_i).each do |number|
  number = number.to_s
  next if throw_away_part1?(number)

  count += 1
  count2 += 1 if double_and_not_triple?(number)
end
finish = Time.now
diff = finish - start

puts "Day4     Time:\t#{diff}"
puts "        part1:\t#{count}"
puts "        part2:\t#{count2}"

# RLE
count = 0
count2 = 0

start = Time.now
(range[0].to_i..range[1].to_i).each do |number|
  number = number.to_s
  next if throw_away_part1_rle(number)

  count += 1
  count2 += 1 if rle_has_single_double?(rle_encode(number))
end
finish = Time.now
diff = finish - start

puts "Day4 RLE Time:\t#{diff}"
puts "        part1:\t#{count}"
puts "        part2:\t#{count2}"
