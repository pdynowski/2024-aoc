require_relative '../utils/input_parser'
require 'pry'

class Grid
  attr_reader :grid, :rows, :columns, :x_coords, :xmas_count, :a_coords, :x_mas_count

  def initialize(grid)
    @grid = grid
    @rows = grid.length
    @columns = grid.first.length
    @x_coords = find_xs
    @xmas_count = count_xmas
    @a_coords = find_as
    @x_mas_count = count_x_mas
  end

  def find_xs
    x_coords = []
    grid.each_with_index do |row, r_idx|
      row.each_with_index do |content, c_idx|
        x_coords << [r_idx, c_idx] if content == 'X'
      end
    end
    x_coords
  end

  def find_as
    a_coords = []
    grid.each_with_index do |row, r_idx|
      row.each_with_index do |content, c_idx|
        a_coords << [r_idx, c_idx] if content == 'A'
      end
    end
    a_coords

  end

  def check_for_xmas(point)
    xmas_count = 0
    xmas_count += 1 if xmas_n?(point)
    xmas_count += 1 if xmas_ne?(point)
    xmas_count += 1 if xmas_e?(point)
    xmas_count += 1 if xmas_se?(point)
    xmas_count += 1 if xmas_s?(point)
    xmas_count += 1 if xmas_sw?(point)
    xmas_count += 1 if xmas_w?(point)
    xmas_count += 1 if xmas_nw?(point)
    xmas_count
  end

  def xmas_n?(point)
    y, x = point
    return false if y < 3
    return false unless grid[y-1][x] == 'M'
    return false unless grid[y-2][x] == 'A'
    return false unless grid[y-3][x] == 'S'
    return true
  end

  def xmas_ne?(point)
    y, x = point
    return false if y < 3
    return false if x > columns - 4
    return false unless grid[y-1][x+1] == 'M'
    return false unless grid[y-2][x+2] == 'A'
    return false unless grid[y-3][x+3] == 'S'
    return true
  end

  def xmas_e?(point)
    y, x = point
    return false if x > columns - 4
    return false unless grid[y][x+1] == 'M'
    return false unless grid[y][x+2] == 'A'
    return false unless grid[y][x+3] == 'S'
    return true
  end

  def xmas_se?(point)
    y, x = point
    return false if y > rows - 4
    return false if x > columns - 4
    return false unless grid[y+1][x+1] == 'M'
    return false unless grid[y+2][x+2] == 'A'
    return false unless grid[y+3][x+3] == 'S'
    return true
  end

  def xmas_s?(point)
    y, x = point
    return false if y > rows - 4
    return false unless grid[y+1][x] == 'M'
    return false unless grid[y+2][x] == 'A'
    return false unless grid[y+3][x] == 'S'
    return true
  end

  def xmas_sw?(point)
    y, x = point
    return false if y > rows - 4
    return false if x < 3
    return false unless grid[y+1][x-1] == 'M'
    return false unless grid[y+2][x-2] == 'A'
    return false unless grid[y+3][x-3] == 'S'
    return true
  end

  def xmas_w?(point)
    y, x = point
    return false if x < 3
    return false unless grid[y][x-1] == 'M'
    return false unless grid[y][x-2] == 'A'
    return false unless grid[y][x-3] == 'S'
    return true
  end

  def xmas_nw?(point)
    y, x = point
    return false if y < 3
    return false if x < 3
    return false unless grid[y-1][x-1] == 'M'
    return false unless grid[y-2][x-2] == 'A'
    return false unless grid[y-3][x-3] == 'S'
    return true
  end

  def check_for_x_mas(point)
    y, x = point
    return 0 if y == 0 || y == rows - 1
    return 0 if x == 0 || x == columns - 1
    return 1 if mas_se?(point) && mas_ne?(point)
    0
  end

  def mas_se?(point)
    y, x = point
    return true if grid[y-1][x-1] == 'S' && grid[y+1][x+1] == 'M'
    return true if grid[y-1][x-1] == 'M' && grid[y+1][x+1] == 'S'
    false
  end

  def mas_ne?(point)
    y, x = point
    return true if grid[y-1][x+1] == 'S' && grid[y+1][x-1] == 'M'
    return true if grid[y-1][x+1] == 'M' && grid[y+1][x-1] == 'S'
    false
  end

  def count_xmas
    x_coords.reduce(0) do |count, point|
      count + check_for_xmas(point)
    end
  end

  def count_x_mas
    a_coords.reduce(0) do |count, point|
      count + check_for_x_mas(point)
    end
  end
end

parser = ->(line) do
  line.strip.split('')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

# p parsed_input

grid = Grid.new(parsed_input)
p grid.xmas_count
p grid.x_mas_count

