#!/usr/bin/env ruby
# frozen_string_literal: true

# Extracts the relative file paths from a .NET stack trace.

YELLOW = "\e[33m"
RESET = "\e[0m"

path = ARGV[0] || 'test.txt'
unless File.exist?(path)
  warn "File not found: #{path}"
  exit 1
end

text = File.read(path)
frames = text.split(/(?=\bat\s)/)

frames.each do |frame|
  next unless frame.start_with?('at ') && !frame.start_with?('at Microsoft')

  match = frame.match(/ in (.+)$/)
  next unless match

  rel = match[1]
            .gsub(/[\\]+/, '/')
            .gsub(%r{/{2,}}, '/')
            .sub(%r{\A[a-z]:/a/1/s/}i, '')
            .strip
  puts "#{YELLOW}#{rel}#{RESET}"
end
