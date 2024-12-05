require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.split(' ')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

first_list = []
second_list = []

parsed_input.each do |line|
  first_list << line[0].to_i
  second_list << line[1].to_i
end

first_list.sort!
second_list.sort!

def calc_dist(first_list, second_list)
  first_list.each_with_index.reduce(0) do |acc, (val, idx)|
    acc + (val - second_list[idx]).abs
  end
end

# puts calc_dist(first_list, second_list)

def calc_similarity(first_list, second_list)
  first_list.reduce(0) do |acc, val|
    acc + (val * second_list.count(val))
  end
end

puts calc_similarity(first_list, second_list)
