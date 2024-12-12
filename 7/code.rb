require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  result, inputs = line.strip.split(': ')
  return {
    result: result.to_i,
    inputs: inputs.split(' ').map(&:to_i)
  }
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

available_operators = ['+', '*', 'cat']

class Integer
  def cat(n)
    (self.to_s + n.to_s).to_i
  end
end

def possible_results(available_operators, inputs, possible_results = [])
  possible_results << inputs.first and return if inputs.length == 1

  available_operators.each do |operator|
    possible_results
    dup_inputs = inputs.dup
    targets = dup_inputs.shift(2)
    new_first_number = targets[0].send(operator, targets[1])
    dup_inputs.unshift(new_first_number)
    possible_results(available_operators, dup_inputs, possible_results)
  end
  possible_results
end

results = parsed_input.select do |calculation|
  possible_results(available_operators, calculation[:inputs]).include?(calculation[:result])
end

p results.reduce(0) {|sum, calc| sum + calc[:result]}