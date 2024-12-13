require_relative '../utils/input_parser'
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
  game['prize'] = { 'x' => group[2][1][1].to_i, 'y' => group[2][2][1].to_i }
  games << game
end


def winning_pairs(game)
  winning_pairs = []
  (1..100).to_a.each do |a|
    (1..100).to_a.each do |b|
      if (game['a']['x'] * a + game['b']['x'] * b == game['prize']['x']) && (game['a']['y'] * a + game['b']['y'] * b == game['prize']['y'])
        winning_pairs << [a,b]
      end
    end
  end
  winning_pairs
end

winning_pairs = games.map do |game|
  winning_pairs(game)
end

cost = winning_pairs.reduce(0) do |sum, game|
  sum + game.reduce(0) do |sum_g, winners|
    sum_g + 3*winners[0] + winners[1]
  end
end

p cost