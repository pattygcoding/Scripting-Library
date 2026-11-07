#!/usr/bin/env ruby
# frozen_string_literal: true

# Prints the path of a frequently used directory.
#
# A child process cannot change its parent shell's working directory, so this
# prints the destination instead. Use it as: cd "$(ruby goto.rb repos)"

DESTINATIONS = {
  'locals' => '', # Insert your locals path here
  'repos' => ''   # Insert your repos path here
}.freeze

target = ARGV[0]
path = target && DESTINATIONS[target.downcase]

if path.nil? || path.empty?
  warn "Option '#{target}' does not exist."
  warn "\nAvailable options:"
  DESTINATIONS.each { |name, dest| warn format('  %-8s - %s', name, dest) }
  exit 1
end

puts path
