require_relative '../utils/input_parser'
require_relative '../utils/mapping'
require 'pry'

parser = ->(line) do
  line.strip.split('')
end

parsed_input = InputParser.parse_input(test_state: true, parser: parser)

class Position
  attr_accessor :coordinates, :facing

  def initialize(coordinates, facing)
    @coordinates = coordinates
    @facing = facing
  end
end

class OlympicMap < Mapping

  attr_accessor :walls, :start_position, :end_coordinates, :location_values, :position_chains, :visited_positions, :end_values

  def initialize(grid)
    super(grid)
    @walls = []
    @start_position = nil
    @end_coordinates = nil
    set_locations
    @location_values = Hash.new { |hash, key| hash[key] = nil }
    @visited_positions = Set.new.add(start_position)
    # print_grid
    @end_values = []
    traverse_grid(start_position)
  end

  def traverse_grid(position, chain_value = 0)
    DIRS.each do |dir|
      if dir == position.facing
        new_position = Position.new(position.coordinates + dir, position.facing)
        if new_position.coordinates == end_coordinates
          @end_values << chain_value + 1
          puts "End reached at: #{chain_value + 1}"
        elsif !walls.include?(new_position.coordinates)
          if location_values[new_position.coordinates].nil? || location_values[new_position.coordinates] > chain_value + 1
            update_positions(new_position, chain_value, 1)
          end
        end
      else
        new_position = Position.new(position.coordinates + dir, dir)
        value = 1000*([(position.facing.real-dir.real).abs, (position.facing.imag-dir.imag).abs].max) + 1
        if location_values[new_position.coordinates].nil? || location_values[new_position.coordinates] > chain_value + value
          if !walls.include?(new_position.coordinates)
            update_positions(new_position, chain_value, value)
          end
        end
      end
    end
  end

  def update_positions(position, chain_value, value)
    location_values[position.coordinates] = chain_value + value
    traverse_grid(position, chain_value + value)
  end

  def min_route
    end_values.min
  end

  def set_locations
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        case cell
        when '#'
          walls << Complex(x,y)
        when 'S'
          @start_position = Position.new(Complex(x,y), Complex(1,0))
        when 'E'
          @end_coordinates = Complex(x,y)
        end
      end
    end
  end

  def print_grid
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        print cell
      end
      puts
    end
    puts
  end
end

map = OlympicMap.new(parsed_input)

p map.min_route
