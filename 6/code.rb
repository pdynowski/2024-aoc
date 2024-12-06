require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split('')
end

class Maze
  attr_accessor :position_x, 
                :position_y, 
                :facing, 
                :maze,
                :obstacle_positions

  def initialize(maze)
    @maze = maze
    @facing = '^'
    @obstactle_positions = []
    find_initial_position
    find_visited_positions
  end

  def find_initial_position
    maze.each_with_index do |row, r|
      row.each_with_index do |col, c|
        @obstactle_positions << [r, c] if col == '#'
        @position_y, @position_x = [r, c] if col == '^'
      end
    end
  end

  def count_visited_positions
    maze.reduce(0) { |acc, row| acc + row.count('X') }
  end

  def on_board?
    position_x >= 0 && position_x < maze.first.length && position_y >= 0 && position_y < maze.length
  end

  def mark_current_position
    maze[position_y][position_x] = 'X'
  end

  def move_guard
    case facing
    when '^'
      if maze[position_y-1]&.[](position_x) == '#'
        @facing = '>'
      else
        @position_y -= 1
      end
    when '>'
      if maze[position_y]&.[](position_x+1 )== '#'
        @facing = 'v'
      else
        @position_x += 1
      end
    when 'v'
      if maze[position_y+1]&.[](position_x) == '#'
        @facing = '<'
      else
        @position_y += 1
      end
    when '<'
      if maze[position_y]&.[](position_x-1) == '#'
        @facing = '^'
      else
        @position_x -= 1
      end
    end
  end

  def find_visited_positions
    while on_board? do
      mark_current_position
      move_guard
    end
  end
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

maze = Maze.new(parsed_input)
p maze.count_visited_positions

