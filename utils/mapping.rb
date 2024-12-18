class Mapping

  DIRS = [0-1i, 1+0i, 0+1i, -1+0i]

  attr_reader :grid, :walls

  def initialize(grid)
    @grid = grid
    @walls = find_walls
  end

  def find_walls
    wall_locs = []
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        wall_locs << Complex(x, y) if cell == '#'
      end
    end
    wall_locs
  end

  def add_wall(location)
    walls << location
    grid[location.imag][location.real] = '#'
  end

  def value(point)
    grid[point.imag][point.real]
  end

  def on_grid?(point)
    in_x_range?(point.real) && in_y_range?(point.imag)
  end

  def in_x_range?(x)
    x.between?(0, grid.first.length - 1)
  end

  def in_y_range?(y)
    y.between?(0, grid.length - 1)
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

  def composite_key(location, facing)
    "#{location.real},#{location.imag},#{DIRS.find_index(facing)}"
  end

  def solve_maze(start, endpoint, facing=Complex(1,0))
    score = 0
    visitation_queue = [[start, facing, 0]]
    visited_locations = Set.new

    while visitation_queue.length > 0 do
      visitation_queue.sort! do |l1, l2| 
        l1[2] <=> l2[2]
      end

      location, facing, score = visitation_queue.shift
      key = composite_key(location, facing)

      return score if location == endpoint
      next if visited_locations.include?(key)

      visited_locations.add(key)

      new_location = location + facing

      if !walls.include?(new_location) && on_grid?(new_location)
        visitation_queue << [new_location, facing, score + 1]
      end

      visitation_queue << [location, facing*Complex(0,-1), score]
      visitation_queue << [location, facing*Complex(0,1), score]
    end 
    return false
  end

end