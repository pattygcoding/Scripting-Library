#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates a random password.

require 'optparse'
require 'securerandom'

CHARACTERS = [*'a'..'z', *'A'..'Z', *'0'..'9', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+'].freeze
DEFAULT_LENGTH = 12

def main
  options = parse_options
  password = Array.new(options[:length]) { CHARACTERS.sample(random: SecureRandom) }.join
  puts "Generated password: #{password}"
end

def parse_options
  options = { length: DEFAULT_LENGTH }
  OptionParser.new do |opts|
    opts.banner = 'Usage: random_password.rb [--length N]'
    opts.on('-l', '--length N', Integer, "Password length (default: #{DEFAULT_LENGTH})") { |n| options[:length] = n }
  end.parse!
  abort 'Error: length must be positive.' if options[:length] < 1
  options
end

main if __FILE__ == $PROGRAM_NAME
