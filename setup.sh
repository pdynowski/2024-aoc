#!/bin/sh

# This script will create the folders for the file structure I'm using for
# Advent of Code 2024
# Starts at day 4 because I didn't think to do it earlier

for i in {4..25}
do
	mkdir $i
	mkdir $i/data
	touch $i/data/test_data.txt
	touch $i/data/data.txt
	touch $i/code.rb

	cat <<-EOF >$i/code.rb
		require_relative '../utils/input_parser'
		require 'pry'

		parser = ->(line) do
		end

		parsed_input = InputParser.parse_input(test_state: true, parser: parser)
	EOF

done