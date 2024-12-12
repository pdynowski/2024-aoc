require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split('').map(&:to_i)
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

class Tree
  attr_accessor :children
  attr_reader :value, :location

  def initialize(value, location)
    @value = value
    @location = location
    @children = []
  end

  def nodes_at_n(level)
    return location if value == level
    children.map { |child| child.nodes_at_n(level) }.flatten
  end

end

class Grid

  DIRS = [0-1i, 1+0i, 0+1i, -1+0i]

  attr_reader :zeroes, :grid, :trees

  def initialize(grid)
    @grid = grid
    find_zeroes
    build_trees
  end

  def find_zeroes
    @zeroes = Set.new
    grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        @zeroes.add(Complex(c,r)) if cell == 0
      end
    end
  end

  def point_value(point)
    grid[point.imag][point.real]
  end

  def add_children(tree)
    DIRS.each do |dir|

      point = tree.location + dir
      if on_grid?(point) && point_value(point) == tree.value + 1
        child_tree = Tree.new(tree.value + 1, point)
        add_children(child_tree)
        tree.children << child_tree
      end
    end
  end

  def build_trees
    @trees = zeroes.map do |zero|
      tree = Tree.new(0, zero)
      add_children(tree)
      tree
    end
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
end


grid = Grid.new(parsed_input)

p grid.trees.reduce(0) {|sum, tree| sum + tree.nodes_at_n(9).to_set.size }
