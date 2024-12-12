require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split('').map(&:to_i)
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser).first
# parsed_input = [1,2,3,4,5]

memory_array = []

file_id = 0

parsed_input.each_with_index do |val, idx|
  if idx % 2 == 0
    val.times { |_| memory_array << file_id }
    file_id += 1
  else
    val.times { |_| memory_array << '.' }
  end
end

p memory_array

until memory_array.find_index('.') > memory_array.rindex { |n| n != '.' } do
  target_index = memory_array.find_index('.')
  source_index = memory_array.rindex{|n| n != '.'}
  memory_array[target_index] = memory_array[source_index]
  memory_array[source_index] = '.'
end

last_index = memory_array.find_index('.')
p memory_array[0...last_index].each_with_index.reduce(0) { |sum, (mem, idx)| sum + mem * idx }