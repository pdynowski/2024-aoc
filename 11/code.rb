require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.strip.split(' ').map(&:to_i)
end

stones = InputParser.parse_input(test_state: false, parser: parser).first

stone_counts = Hash.new { |hash, key| hash[key] = 0 }
stone_evos = Hash.new { |hash, key| hash[key] = Hash.new { 0 } }

stones.each { |stone| stone_counts[stone] += 1 }
stone_evos[0] = { 1 => 1 }
stone_evos[1] = { 2024 => 1 }

def split_stone(stone)
  if stone[0...stone.length/2].join.to_i == [stone[stone.length/2..-1]].join.to_i
    return { stone[0...stone.length/2].join.to_i => 2 }
  else
    return { stone[0...stone.length/2].join.to_i => 1, [stone[stone.length/2..-1]].join.to_i => 1 }
  end
end


75.times do
  new_stones = Hash.new { |hash, key| hash[key] = 0 }
  stone_counts.keys.each do |stone|
    if !stone_evos[stone].empty?
      stone_evos[stone].each do |key, val|
        new_stones[key] += val * stone_counts[stone]
      end
    else
      if stone.to_s.chars.length % 2 == 0
        stone_evos[stone] = split_stone(stone.to_s.chars)
        split_stone(stone.to_s.chars).each do |k, v|
          new_stones[k] += v * stone_counts[stone]
        end
      else
        stone_evos[stone][2024*stone] += 1
        new_stones[2024*stone] = stone_counts[stone]
      end
    end
  end
  stone_counts = new_stones
end

p stone_counts.reduce(0) { |sum, (_, v)| sum + v }

