require_relative '../utils/input_parser'
require_relative '../utils/mapping'
require 'pry'

class Region

  attr_accessor :points
  attr_reader :id

  def initialize(points, id)
    @points = points
    @id = id
  end

  def area
    points.size
  end

  def perimeter
    points.reduce(0) do |sum, point|
      sum + 4 - neighbors(point).count
    end
  end

  def neighbors(target_point)
    neighbors = []
    Mapping::DIRS.each do |dir|
      point = target_point + dir
      neighbors << point if points.include?(point)
    end
    neighbors
  end

  def cost
    area * perimeter
  end

  def mod_cost
    area * sides
  end

  def sides
    exterior_corners = 0
    interior_corners = 0
    points.each do |point|
      exterior_corners += 1 if !points.include?(point + Complex(1,0)) && !points.include?(point + Complex(0,-1))
      exterior_corners += 1 if !points.include?(point + Complex(1,0)) && !points.include?(point + Complex(0,1))
      exterior_corners += 1 if !points.include?(point + Complex(-1,0)) && !points.include?(point + Complex(0,-1))
      exterior_corners += 1 if !points.include?(point + Complex(-1,0)) && !points.include?(point + Complex(0,1))
      interior_corners += 1 if !points.include?(point + Complex(0,-1)) && points.include?(point + Complex(1,0)) && points.include?(point + Complex(1,-1))
      interior_corners += 1 if !points.include?(point + Complex(0,-1)) && points.include?(point + Complex(-1,0)) && points.include?(point + Complex(-1,-1))
      interior_corners += 1 if !points.include?(point + Complex(1,0)) && points.include?(point + Complex(0,-1)) && points.include?(point + Complex(1,-1))
      interior_corners += 1 if !points.include?(point + Complex(1,0)) && points.include?(point + Complex(0,1)) && points.include?(point + Complex(1,1))
      interior_corners += 1 if !points.include?(point + Complex(0,1)) && points.include?(point + Complex(1,0)) && points.include?(point + Complex(1,1))
      interior_corners += 1 if !points.include?(point + Complex(0,1)) && points.include?(point + Complex(-1,0)) && points.include?(point + Complex(-1,1))
      interior_corners += 1 if !points.include?(point + Complex(-1,0)) && points.include?(point + Complex(0,1)) && points.include?(point + Complex(-1,1))
      interior_corners += 1 if !points.include?(point + Complex(-1,0)) && points.include?(point + Complex(0,-1)) && points.include?(point + Complex(-1,-1))
    end
    exterior_corners + interior_corners/2
  end

  def border?(point, point_id)
    return false if id != point_id
    return true if points.any? { |pt| pt == point + Complex(1,0)}
    return true if points.any? { |pt| pt == point + Complex(0,1)}
    return true if points.any? { |pt| pt == point - Complex(1,0)}
    return true if points.any? { |pt| pt == point - Complex(0,1)}
    return false
  end
end

parser = ->(line) do
  line.strip.split('')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

# parsed_input = [['A', 'A', 'A', 'A'],['B', 'B', 'C', 'D'],['B', 'B', 'C', 'C'],['E', 'E', 'E', 'C']]

# p parsed_input

def build_region(map, region, point, unvisited_points)
  dirs = Mapping::DIRS
  starting_point = point
  
  dirs.each do |dir|
    point = starting_point + dir
    if map.on_grid?(point) && unvisited_points.include?(point) && map.value(point) == region.id
      region.points.add(point)
      unvisited_points.delete(point)
      build_region(map, region, point, unvisited_points)
    end
  end

end

def build_regions(grid)
  regions = []
  map = Mapping.new(grid)
  unvisited_points = Set.new
  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      unvisited_points.add(Complex(c, r))
    end
  end

  while !unvisited_points.empty?
    puts unvisited_points.first
    visited_points = Set.new
    starting_point = unvisited_points.first
    visited_points.add(starting_point)
    unvisited_points.delete(starting_point)
    region = Region.new(visited_points, map.value(starting_point))
    build_region(map, region, starting_point, unvisited_points)
    regions << region
  end

  regions
end

regions = build_regions(parsed_input)

regions.each do |region|
  puts "Region #{region.id}, area: #{region.area}, perimeter: #{region.perimeter}, cost: #{region.cost}"
end

p regions.sum {|region| region.cost }

regions.each do |region|
  puts "Region #{region.id}, area: #{region.area}, sides: #{region.sides}, cost: #{region.mod_cost}"
end
p regions.sum {|region| region.mod_cost }
