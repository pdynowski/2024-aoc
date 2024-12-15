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

mod_grid = []

grid.map do |row|
  line = []
  row.each do |cell|
    case cell
    when '#'
      line << '##'
    when '@'
      line << '@.'
    when 'O'
      line << '[]'
    when '.'
      line << '..'
    end
  end
  mod_grid << line.join.split('')
end

class Box

  attr_accessor :position, :extent

  def initialize(position)
    @position = position
    @extent = [position.dup, position + Complex(1,0)]
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
        when '['
          boxes << Box.new(Complex(x, y))
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
    boxes_to_move = []
    position_to_check = robot_position + direction
    return if walls.include?(position_to_check)

    positions_to_check = [robot_position + direction]
    values_to_check = positions_to_check.map { |p| value(p) }

    while !values_to_check.include?('.') && !values_to_check.include?('#')
      positions_to_check.each do |position_to_check|
        box = boxes.select {|b| b.extent.include? position_to_check }.first
        if box && !boxes_to_move.include?(box)
          boxes_to_move << box
          box.extent.each {|l| positions_to_check << (l + direction)}
        end
        values_to_check = positions_to_check.uniq.map { |p| value(p) }.uniq
      end
    end

    return if values_to_check.include?('#')

    boxes_to_move.reverse.each do |box|
      box.position += direction
      box.extent.each do |space|
        grid[space.imag][space.real] = '.'
      end

      box.extent = box.extent.map { |b| b + direction }

      box.extent.each do |space|
        if space == box.position
          grid[(space).imag][(space).real] = '['
        else
          grid[(space).imag][(space).real] = ']'
        end
      end
      
    end

    spaces_to_move.reverse.each do |space|
      grid[robot_position.imag][robot_position.real] = '.'
      @robot_position += direction
      grid[robot_position.imag][robot_position.real] = '@'
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

map = WarehouseMap.new(mod_grid, moves.flatten)
map.print_grid
gps_sum = map.boxes.reduce(0) { |sum, box| sum + box.position.real + 100*box.position.imag }

p gps_sum