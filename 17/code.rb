require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split(': ')
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

start_hash = {}

parsed_input.each do |el|
  if !el.empty?
    if /Register/.match el[0]
      start_hash[el[0]] = el[1].to_i
    else
      start_hash[el[0]] = el[1].split(',').map(&:to_i)
    end
  end
end

class Computer

  attr_accessor :a, :b, :c, :instructions, :current_instruction_pointer, :next_instruction_pointer, :output

  def initialize(initialization)
    @a = initialization['Register A']
    @b = initialization['Register B']
    @c = initialization['Register C']
    @instructions = initialization['Program']
    @current_instruction_pointer = 0
    @next_instruction_pointer = 0
    @output = []
  end

  def run_program
    while (current_instruction_pointer < instructions.length)
      # puts "Current pointer: #{@current_instruction_pointer}"
      # puts "Instruction: #{instructions[@current_instruction_pointer]}"
      # puts "Operand: #{instructions[@current_instruction_pointer+1]}"
      # puts "Register A: #{a}" 
      # puts "Register B: #{b}" 
      # puts "Register C: #{c}" 
      # puts "Output: #{output}"
      # puts "Instructions: #{instructions}"
      operate(instructions[@current_instruction_pointer], instructions[@current_instruction_pointer+1])
      if @next_instruction_pointer == @current_instruction_pointer
        @current_instruction_pointer += 2
        @next_instruction_pointer = current_instruction_pointer
      else
        @current_instruction_pointer = @next_instruction_pointer
        @next_instruction_pointer = @current_instruction_pointer
      end
    end
  end

  def get_value(opcode)
    case opcode
    when 0, 1, 2, 3
      opcode
    when 4
      @a
    when 5
      @b
    when 6
      @c
    else
      raise "invalid instruction"
    end
  end

  def operate(opcode, operand)
    case opcode
    when 0
      x = get_value(operand)
      @a /= 2 ** x
    when 1
      @b = (@b ^ operand)
    when 2
      @b = get_value(operand) % 8
    when 3
      unless @a == 0
        @next_instruction_pointer = operand
      end
    when 4
      @b = (@b ^ @c)
    when 5
     output << get_value(operand) % 8
    when 6
      x = get_value(operand)
      @b = @a / (2 ** x)
    when 7
      x = get_value(operand)
      @c = @a / (2 ** x)
    end
  end
end

computer = Computer.new(start_hash)

computer.run_program

p computer.output.join(',')

possibles = [0]
solutions = []

(1..start_hash['Program'].length).each do |n|
  next_possibles = possibles.map do |possible|
    posses = []
    (possible..possible+8).each do |poss|
      start_hash['Register A'] = poss
      computer = Computer.new(start_hash)
      computer.run_program
      posses << (8*poss) if (computer.output[-n..-1] == computer.instructions[-n..-1])
      solutions << poss if computer.output == computer.instructions
    end
    posses
  end.flatten
  possibles = next_possibles
end

p solutions.min

