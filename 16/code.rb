require_relative '../utils/input_parser'
require_relative '../utils/mapping'
require_relative '../utils/patches'
require 'pry'

parser = ->(line) do
  line.strip.split('')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

class Position
  attr_accessor :coordinates, :facing

  def initialize(coordinates, facing)
    @coordinates = coordinates
    @facing = facing
  end
end

class OlympicMap < Mapping

  attr_accessor :walls, :start_position, :end_coordinates, :location_values, :visited_locations, :visitation_queue

  def initialize(grid)
    super(grid)
    @walls = []
    @start_position = nil
    @end_coordinates = nil
    @location_values = Hash.new { |hash, key| hash[key] = nil }
    set_locations
    @visited_locations = Set.new
    @visitation_queue = [[start_position, 0]]
  end

  def composite_key(position)
    "#{position.coordinates.real},#{position.coordinates.imag},#{DIRS.find_index(position.facing)}"
  end

  def solve_maze
    score = 0
    while visitation_queue.length > 0 do
      visitation_queue.sort! {|l1, l2| l1[1] <=> l2[1]}

      location = visitation_queue.shift
      position = location[0]
      score = location[1]
      key = composite_key(position)

      return score if position.coordinates == end_coordinates
      next if visited_locations.include?(key)

      visited_locations.add(key)

      new_position = Position.new(position.coordinates + position.facing, position.facing)
      if !walls.include?(new_position.coordinates)
        visitation_queue << [new_position, score + 1]
      end

      right_turn = Position.new(position.coordinates, position.facing * Complex(0,-1))
      left_turn = Position.new(position.coordinates, position.facing * Complex(0,1))
      visitation_queue << [right_turn, score+1000]
      visitation_queue << [left_turn, score+1000]
    end 
    return score
  end

  def get_paths(cheapest_route)
    queue = [[start_position, 0, [start_position]]]

    visited = Hash.new { |hash, key| hash[key] = 10000000000000000 }
    paths = []
    while queue.length > 0 do

      position, score, path = queue.shift

      key = composite_key(position)
      next if score > cheapest_route
      next if visited[key] < score

      visited[key] = score
      if position.coordinates == end_coordinates && score == cheapest_route
        paths << path
        next
      end

      new_position = Position.new(position.coordinates + position.facing, position.facing)
      if !walls.include?(new_position.coordinates)
        queue << [new_position, score + 1, path.deep_dup << new_position]
      end

      right_turn = Position.new(position.coordinates, position.facing * Complex(0,-1))
      left_turn = Position.new(position.coordinates, position.facing * Complex(0,1))
      queue << [right_turn, score+1000, path.deep_dup]
      queue << [left_turn, score+1000, path.deep_dup]
    end
    return paths
  end

  def set_locations
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        case cell
        when '#'
          walls << Complex(x,y)
        when 'S'
          @start_position = Position.new(Complex(x,y), Complex(1,0))
          @location_values[composite_key(@start_position)] = 0
        when 'E'
          @end_coordinates = Complex(x,y)
        end
      end
    end
  end
end

map = OlympicMap.new(parsed_input)

# s = Time.now
# p map.solve_maze
# puts "Elapsed time: #{Time.now - s}"

s = Time.now
paths = map.get_paths(73432)
locations = Set.new
paths.each {|path| path.each {|pos| locations << pos.coordinates } }
p locations.length
puts "Elapsed time: #{Time.now - s}"


# 7036/73432
