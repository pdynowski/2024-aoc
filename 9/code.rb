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
    val.times { |_| memory_array << nil }
  end
end

p memory_array

beg_idx = 0
end_idx = memory_array.length - 1

while beg_idx < end_idx do
  if !memory_array[beg_idx].nil?
    beg_idx += 1
  elsif memory_array[end_idx].nil?
    end_idx -= 1
  else
    memory_array[beg_idx] = memory_array[end_idx]
    memory_array[end_idx] = nil
  end
  p end_idx - beg_idx
end

last_index = memory_array.find_index(nil)
p memory_array[0...last_index].each_with_index.reduce(0) { |sum, (mem, idx)| sum + mem * idx }