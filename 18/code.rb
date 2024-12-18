require_relative '../utils/input_parser'
require_relative '../utils/mapping'
require 'pry'

parser = ->(line) do
  arr = line.strip.split(',').map(&:to_i)
  arr.length > 1 ? Complex(arr[0], arr[1]) : arr.first
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

bytes_to_use = parsed_input.shift
grid_size = parsed_input.shift

blocked_bytes = parsed_input.slice(0, bytes_to_use)

map_input = []

(0..grid_size).each do |y|
  row = []
  (0..grid_size).each do |x|
    blocked_bytes.include?(Complex(x,y)) ? row << '#' : row << '.'
  end
  map_input << row
end

map = Mapping.new(map_input)

# map.print_grid

start = Complex(0,0)
endpoint = Complex(grid_size, grid_size)

p map.solve_maze(start, endpoint)

btu_lower = bytes_to_use
btu_upper = parsed_input.length - 1


loop do
  bytes_to_use = (btu_lower + btu_upper) / 2
  puts btu_lower
  puts bytes_to_use
  puts btu_upper
  puts
  test_input = parsed_input.slice(0, bytes_to_use)
  map_input = []
  (0..grid_size).each do |y|
    row = []
      (0..grid_size).each do |x|
        test_input.include?(Complex(x,y)) ? row << '#' : row << '.'
      end
      map_input << row
  end
  map = Mapping.new(map_input)

  if map.solve_maze(start, endpoint)
    btu_lower = bytes_to_use
  else
    btu_upper = bytes_to_use
  end
  break if btu_lower == btu_upper - 1
end
p parsed_input.slice(0, btu_upper).last