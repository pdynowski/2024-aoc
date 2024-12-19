require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  arr = line.strip.split(', ')
  if arr.length == 1
    arr = arr[0]
  end
  arr
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

patterns = parsed_input.shift
parsed_input.shift

designs = parsed_input

pattern_regex = /^#{Regexp.union(*patterns)}+$/

def design_possible?(design, pattern_regex)
  design =~ pattern_regex
end

def pattern_count(design, patterns, cache = {})
  if cache[design]
    cache[design]
  elsif design == ''
    1
  else
    cache[design] = patterns.select {|pattern| design.start_with?(pattern) }.map {|pattern| pattern_count(design[pattern.size..-1], patterns, cache)}.sum
  end
end

p designs.count { |design| design_possible?(design, pattern_regex) }
p designs.map { |design| pattern_count(design, patterns) }.sum

