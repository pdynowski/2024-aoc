require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
end

parsed_input = InputParser.parse_input(test_state: true, parser: parser)
