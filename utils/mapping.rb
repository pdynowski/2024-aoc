class Mapping

  DIRS = [0-1i, 1+0i, 0+1i, -1+0i]

  attr_reader :grid

  def initialize(grid)
    @grid = grid
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

end