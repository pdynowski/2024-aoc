require_relative '../utils/input_parser'
require 'matrix'
require 'pry'

parser = ->(line) do
  line.strip.split(':').map do |s| 
    s.split(',')
  end.flatten.map do |s|
    s.split(/[+=]/)
  end
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

games = []

create_games = parsed_input.each_slice(4) do |group|
  game = {}
  game['a'] = { 'x' => group[0][1][1].to_i, 'y' => group[0][2][1].to_i }
  game['b'] = { 'x' => group[1][1][1].to_i, 'y' => group[1][2][1].to_i }
  game['prize'] = { 'x' => 10000000000000 + group[2][1][1].to_i, 'y' => 10000000000000 + group[2][2][1].to_i }
  games << game
end


def winning_pairs(game)
  equations = [ [game['a']['x'], game['b']['x']], [game['a']['y'], game['b']['y']] ]
  results = [ game['prize']['x'], game['prize']['y'] ]
  matrix = Matrix.rows(equations)
  res = Matrix.column_vector(results)
  solutions = matrix.lup_decomposition.solve(res).to_a
  a = solutions.first.first.denominator == 1 ? solutions.first.first.numerator : nil
  b = solutions.last.first.denominator == 1 ? solutions.last.first.numerator : nil
  [a, b].compact
end


winning_pairs = games.map do |game|
  winning_pairs(game)
end

cost = winning_pairs.reduce(0) do |sum, pair|
  if pair.empty? || (pair[0].nil? || pair[1].nil?)
    sum
  else
    sum + 3*pair[0] + pair[1]
  end
end

p cost


