require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split('').map(&:to_i)
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser).first

memory_array = []
files = []

file_id = 0
current_idx = 0

class MemFile
  attr_accessor :id, 
                :location, 
                :size

  def initialize(id, location, size)
    @id = id
    @location = location
    @size = size
  end

  def checksum
    (location...size + location).reduce(0) { |sum, n| sum + n * id }
  end
end

current_file = nil

parsed_input.each_with_index do |val, idx|
  if idx % 2 == 0
    val.times { |_| memory_array << file_id }
    files[file_id] = MemFile.new(file_id, current_idx, val)
    file_id += 1
  else
    val.times { |_| memory_array << nil }
  end
  current_idx += val
end

# defrag individual blocks
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
end

last_index = memory_array.find_index(nil)
p memory_array[0...last_index].each_with_index.reduce(0) { |sum, (mem, idx)| sum + mem * idx }
# ---------------------------
# defrag whole files
files.reverse.each do |file|
  space = 0
  first_empty_idx = file.location
  no_space = false
  until space >= file.size || no_space do
    files.sort_by { |file| file.location }.each_cons(2) do |file_pair|
      first, second = file_pair
      space = second.location - first.location - first.size
      first_empty_idx = first.location + first.size if space >= file.size
      break if space >= file.size
      break if first_empty_idx > file.location
    end
    no_space = true  
  end
  file.location = first_empty_idx unless first_empty_idx > file.location
end

p files.reduce(0) { |sum, file| sum + file.checksum }

