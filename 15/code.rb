require_relative '../utils/input_parser'
require_relative '../utils/mapping'
require 'pry'

parser = ->(line) do
  line.strip.split('')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

grid = []
moves = []

empty_line_encountered = false
parsed_input.each do |line|
  if empty_line_encountered
    moves << line
  elsif line.empty?
    empty_line_encountered = !empty_line_encountered
  else
    grid << line
  end
end


class WarehouseMap < Mapping

  attr_accessor :moves, :boxes, :robot_position, :walls

  def initialize(grid, moves)
    @moves = moves
    super(grid)
    @walls = []
    @robot_position = nil
    @boxes = []
    set_starting_locations
    perform_moves
  end

  def set_starting_locations
    grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        case cell
        when 'O'
          boxes << Complex(x, y)
        when '#'
          walls << Complex(x, y)
        when '@'
          @robot_position = Complex(x, y)
        end
      end
    end
  end

  def perform_moves
    moves.each do |move|
      case move
      when '^'
        move(Complex(0,-1))
      when '>'
        move(Complex(1,0))
      when 'v'
        move(Complex(0,1))
      when '<'
        move(Complex(-1,0))
      end
      # print_grid
    end
  end

  def move(direction)
    spaces_to_move = [robot_position]
    position_to_check = robot_position + direction
    return if walls.include?(position_to_check)

    while !['.', '#'].include? value(position_to_check)
      if boxes.include?(position_to_check)
        spaces_to_move << position_to_check
      end
      position_to_check += direction
    end

    return if walls.include?(position_to_check)

    spaces_to_move.reverse.each do |space|
      if boxes.include?(space)
        boxes.delete(space)
        grid[space.imag][space.real] = '.'
        boxes << space + direction
        grid[(space+direction).imag][(space+direction).real] = 'O'
      else
        grid[robot_position.imag][robot_position.real] = '.'
        @robot_position += direction
        grid[robot_position.imag][robot_position.real] = '@'
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

map = WarehouseMap.new(grid, moves.flatten)
gps_sum = map.boxes.reduce(0) do |sum, box|
  sum + box.real + 100*box.imag
end

p gps_sum

