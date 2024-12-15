require_relative '../utils/input_parser'
require 'pry'

class Robot
  attr_accessor :position, :velocity

  def initialize(pos, vel)
    @position = pos
    @velocity = vel
  end

  def move(width, height)
    @position += velocity
    pos_x = @position.real % width
    pos_y = @position.imag % height
    pos = Complex(pos_x, pos_y)
    @position = pos
  end

end

parser = ->(line) do
  robot= {}
  line.strip.split(' ').each do |s|
    var, val = s.split('=')
    val_x, val_y = val.split(',').map{|v| v.to_i}
    robot[var] = Complex(val_x, val_y)
  end
  Robot.new(robot['p'], robot['v'])
end

robots = InputParser.parse_input(test_state: false, parser: parser)

p robots

# height, width = [7, 11]
height, width = [103, 101]

def robots_in_line(robots, width)
  robot_positions = robots.map{ |r| r.position }
  symm_count = 0
  robot_positions.each do |pos|
    pos_x = pos.real
    pos_y = pos.imag
    line_pos = Complex(pos_x+1, pos_y)
    if robot_positions.include?(line_pos)
      symm_count += 1
    end
  end
  symm_count
end

1000000000000000.times do |t|
  if robots_in_line(robots, width) > robots.length/3
    puts t
    (0..height-1).to_a.each do |y|
      (0..width-1).to_a.each do |x|
        if robots.any? { |r| r.position == Complex(x,y) }
          print '*'
        else
          print '.'
        end
      end
      puts
    end
    puts
    gets
  end
  robots.each { |robot| robot.move(width, height) }
end

q1 = q2 = q3 = q4 = 0

robots.each do |robot|
  q1 += 1 if robot.position.real.between?(0,width/2-1) && robot.position.imag.between?(0,height/2-1)
  q2 += 1 if robot.position.real.between?(0,width/2-1) && robot.position.imag.between?(height/2 + 1,height-1)
  q3 += 1 if robot.position.real.between?(width/2+1,width-1) && robot.position.imag.between?(0,height/2-1)
  q4 += 1 if robot.position.real.between?(width/2+1,width-1) && robot.position.imag.between?(height/2 + 1,height-1)
end

p q1*q2*q3*q4



