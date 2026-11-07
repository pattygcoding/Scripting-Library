#!/usr/bin/env ruby
# frozen_string_literal: true

# Converts a time to India Standard Time (IST).

require 'time'

IST_OFFSET = (5.5 * 3600).to_i
TIME_FORMAT = '%I:%M %p'

def main
  input = ARGV[0]
  if input
    begin
      local = Time.strptime(input, TIME_FORMAT)
    rescue ArgumentError
      warn "Invalid time format. Use format like '8:26 AM'."
      exit 1
    end
    puts "Inputted time in India: #{to_ist(local).strftime(TIME_FORMAT)}"
  else
    puts "Current time in India: #{to_ist(Time.now).strftime(TIME_FORMAT)}"
  end
end

def to_ist(time)
  time.getlocal(IST_OFFSET)
end

main if __FILE__ == $PROGRAM_NAME
