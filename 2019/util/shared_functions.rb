# frozen_string_literal: true

# common functions
def get_list(file_name)
  input_file = format('%<path>s/input/%<day>s_input.txt',
                      day: file_name.match(/\d+\.rb/).to_s.chomp('.rb'),
                      path: File.dirname(file_name))
  file = File.open(input_file)
  return file.readlines.map(&:chomp)
end

def get_array(file_name)
  input_file = format('%<path>s/input/%<day>s_input.txt',
                      day: file_name.match(/\d+\.rb/).to_s.chomp('.rb'),
                      path: File.dirname(file_name))
  file = File.read(input_file).split(',').map(&:strip)
  return file
end

def get_string(filename)
  return get_list(filename)[0]
end

# test function
# print get_string('8.rb')
