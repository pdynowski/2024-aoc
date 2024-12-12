require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split('')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

ANTENNA_LOCATIONS = Hash.new { |hash, key| hash[key] = Set.new }

max_y = parsed_input.length - 1
max_x = parsed_input.first.length - 1

parsed_input.each_with_index do |row, r|
  row.each_with_index do |cell, c|
    if parsed_input[r][c] != '.'
      ANTENNA_LOCATIONS[cell].add(Complex(c, r))
    end
  end
end

limited_antinode_locations = Set.new

ANTENNA_LOCATIONS.each do |type, locations|
  locations.to_a.combination(2).each do |combo|
    diff = combo[1] - combo[0]
    antinodes = [combo[0] - diff, combo[1] + diff]
    antinodes.each do |antinode|
      limited_antinode_locations.add(antinode) if antinode.real.between?(0, max_x) && antinode.imag.between?(0, max_y)
    end
  end
end

puts "Limited antinode locations: #{limited_antinode_locations.size}"

unlimited_antinode_locations = Set.new

def off_x?(x, max_x)
  !x.between?(0, max_x)
end

def off_y?(y, max_y)
  !y.between?(0, max_y)
end

def off_grid?(point, max_x, max_y)
  off_x?(point.real, max_x) || off_y?(point.imag, max_y)
end

ANTENNA_LOCATIONS.each do |type, locations|
  locations.to_a.combination(2).each do |combo|
    diff = combo[1] - combo[0]
    point = combo[0].dup
    until off_grid?(point, max_x, max_y) do
      unlimited_antinode_locations.add(point)
      point -= diff
    end
    point = combo[1].dup
    until off_grid?(point, max_x, max_y) do
      unlimited_antinode_locations.add(point)
      point += diff
    end
  end
end

puts "Unlimited antinode locations: #{unlimited_antinode_locations.size}"