#!/usr/bin/env ruby
# frozen_string_literal: true

# Starts an Angular development server and opens it in the browser.

require 'optparse'

DEFAULT_PORT = 4200
DEFAULT_COMMAND = 'ng serve'

def main
  options = parse_options
  spawn(options[:command])
  open_browser(options[:port])
end

def parse_options
  options = { port: DEFAULT_PORT, command: DEFAULT_COMMAND }
  OptionParser.new do |opts|
    opts.banner = 'Usage: angular-start.rb [--port PORT] [--command CMD]'
    opts.on('--port PORT', Integer, "Dev server port (default: #{DEFAULT_PORT})") { |p| options[:port] = p }
    opts.on('--command CMD', "Command to run (default: '#{DEFAULT_COMMAND}')") { |c| options[:command] = c }
  end.parse!
  options
end

def open_browser(port)
  url = "http://localhost:#{port}/"
  if Gem.win_platform?
    system('cmd', '/c', 'start', '', url)
  elsif RUBY_PLATFORM.include?('darwin')
    system('open', url)
  else
    system('xdg-open', url)
  end
end

main if __FILE__ == $PROGRAM_NAME
