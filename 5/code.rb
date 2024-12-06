require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  if /\d{2}\|\d{2}/.match(line)
    line.split('|').map { |c| c.to_i }
  else
    line.split(',').map { |c| c.to_i }
  end
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

split_index = parsed_input.find_index([0])
rules = parsed_input[0...split_index]
updates = parsed_input[split_index + 1..-1]

def combo_valid?(combo, rules)
  rules.none? { |rule| rule == combo.reverse }
end

def update_valid?(update, rules)
  update.combination(2).all? do |combo|
    combo_valid?(combo, rules)
  end
end

def fix_update(update, rules)
  rules_for_update = {}
  update.combination(2).each do |combo|
    if rules.include?(combo)
      if rules_for_update[combo[0]]
        rules_for_update[combo[0]] << combo[1]
      else
        rules_for_update[combo[0]] = [combo[1]]
      end
    elsif rules.include?(combo.reverse)
      if rules_for_update[combo[1]]
        rules_for_update[combo[1]] << combo[0]
      else
        rules_for_update[combo[1]] = [combo[0]]
      end
    end
  end
  fixed_update = Array.new(rules_for_update.keys.length + 1)
  update.each do |page|
    rules_length = rules_for_update[page].nil? ? 0 : rules_for_update[page].length
    fixed_update[update.length - rules_length - 1] = page
  end
  fixed_update
end

correct_updates = updates.select { |update| update_valid?(update, rules) }
incorrect_updates = updates.reject { |update| update_valid?(update, rules) }

total = correct_updates.reduce(0) do |acc, update|
  acc + update[update.length/2]
end

i_total = incorrect_updates.map { |update| fix_update(update, rules) }.reduce(0) {|acc, update| acc + update[update.length/2]}

p total

p i_total