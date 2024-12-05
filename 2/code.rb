require_relative '../utils/input_parser'
require 'pry'

parser = ->(line) do
  line.split(' ').map do |num|
    num.to_i
  end
end

parsed_input = InputParser.parse_input(test_state: false, parser: parser)

def report_diffs(report)
  report.each_cons(2).map{ |pair| pair[1] - pair[0] }
end

def safe_report?(report)
  diffs = report_diffs(report)
  (diffs.all? { |d| d > 0 } || diffs.all? { |d| d < 0 }) && diffs.all? { |d| d.abs <= 3 }
end

safe_as_is = parsed_input.select do |report|
  safe_report?(report)
end.length

correctable_reports = parsed_input.select do |report|
  !safe_report?(report)
end

safe_when_corrected = correctable_reports.select do |report|
  report.combination(report.length - 1).any? do |combo|
    safe_report?(combo)
  end
end.length

p safe_as_is
p safe_when_corrected
p safe_as_is + safe_when_corrected