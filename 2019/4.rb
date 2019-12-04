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

def double_and_not_triple?(input)
  input = input.to_i.split_digits
  h = {}
  input.each do |v|
    h.store(v, h[v].to_i + 1)
  end

  return h.any? { |_, v| v > 2 }
end

def ascending_order?(input)
  digits = input.to_i.split_digits
  return digits.eql?(digits.sort)
end

def throw_away?(input)
  input = input.to_s
  return true unless ascending_order?(input) && double_and_not_triple?(input)
end

range = get_list(File.absolute_path(__FILE__))
count = 0

start = Time.now
(range[0].to_i..range[1].to_i).each do |number|
  count += 1 unless throw_away?(number)
end
finish = Time.now
diff = finish - start

puts "Main: #{count} - #{diff}"
