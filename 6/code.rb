require_relative '../utils/input_parser'
require_relative '../utils/patches'
require 'pry'

parser = ->(line) do
  line.strip.split('')
end

class Maze
  attr_accessor :position, 
                :maze,
                :visited_positions,
                :unique_visited_positions,
                :dir


  DIRS = [0-1i, 1+0i, 0+1i, -1+0i]

  def initialize(maze)
    @maze = maze
    @unique_visited_positions = Set[]
    @visited_positions = Set[]
    @dir = 0
    @obstacles = []
    @position = nil
    find_initial_positions
    find_visited_positions
  end

  def find_initial_positions
    maze.length.times do |y|
      maze.first.length.times do |x|
        case maze[y][x]
        when ?#
          @obstacles << Complex(x,y)
        when ?^
          @position = Complex(x,y)
        end
      end
    end
  end

  def on_board?
    position.real.between?(0, maze.first.length-1) && position.imag.between?(0, maze.length-1)
  end

  def new_space?
    !visited_positions.include? [position, dir]
  end

  def mark_current_position
    unique_visited_positions << position
    visited_positions.add([position, dir])
  end

  def in_loop?
    visited_positions.include?([position, dir])
  end

  def move_guard
    @position += DIRS[dir]
  end

  def find_visited_positions
    while on_board? && !in_loop? do
      until @obstacles.include?(@position + DIRS[dir]) || !on_board? do
        @unique_visited_positions << @position
        @visited_positions << [@position, dir]
        @position += DIRS[dir]
      end
      @dir = (dir + 1) % 4
    end
  end
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

maze = Maze.new(parsed_input.deep_dup)
initial_visited_positions = maze.unique_visited_positions
p initial_visited_positions.size
new_obs = 0

initial_visited_positions.each_with_index do |pos, idx|
  row = pos.imag
  col = pos.real
  starter_layout = parsed_input.deep_dup
  next if starter_layout[row][col] == '^'
  starter_layout[row][col] = '#'
  new_maze = Maze.new(starter_layout)
  new_obs += 1 if new_maze.in_loop?
end
p new_obs

