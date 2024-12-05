require_relative '../utils/input_parser'
require 'pry'

mul_regex = /mul\(\d*,\d*\)/

parser = ->(line) do
  line.scan(mul_regex).map do |mtch|
    mtch.match(/\d*,\d*/).to_s.split(',').map{ |d| d.to_i }
  end
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

total = parsed_input.reduce(0) do |acc, instruction|
  acc + instruction.reduce(0) do |acc2, entry|
    acc2 + entry[0] * entry[1]
  end
end

# p total


# Part 2 has input that breaks across lines, so general input parser won't work
# input = File.read("#{File.dirname($0)}/data/test_data.txt")
input = File.read("#{File.dirname($0)}/data/data.txt")

# get rid of inputs that don't matter- anything between a don't and a do
input.gsub!(/don't\(\).*?do\(\)/m, '')

p_input = input.scan(mul_regex).map do |mtch|
  mtch.match(/\d*,\d*/).to_s.split(',').map{ |d| d.to_i }
end

tot = p_input.reduce(0) do |acc, instruction|
  acc + instruction.reduce(:*)
end

p tot