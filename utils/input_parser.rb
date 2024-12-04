class InputParser

  attr_reader :test_state, 
              :filename, 
              :parser, 
              :parsed_input

  def initialize(test_state, parser)
    @test_state = test_state
    @parser = parser
    set_input_filename
    parse_input(&parser)
  end

  def set_input_filename
    @filename = "#{File.dirname($0)}#{test_state ? '/data/test_data.txt' : '/data/data.txt'}"
  end

  def parse_input(&block)
    @parsed_input = []
    IO.foreach(File.open(filename)) do |line|
      parsed_input << block.call(line)
    end
  end

  def self.parse_input(test_state: false, parser: block)
    input_parser = InputParser.new(test_state, parser)
    input_parser.parsed_input
  end
end