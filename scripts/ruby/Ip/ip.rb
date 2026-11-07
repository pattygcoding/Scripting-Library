#!/usr/bin/env ruby
# frozen_string_literal: true

# Prints the machine's IPv4 addresses.

require 'socket'

def main
  addresses = Socket.ip_address_list
                    .select(&:ipv4?)
                    .reject(&:ipv4_loopback?)
                    .map(&:ip_address)
                    .uniq
                    .sort
  addresses.each { |address| puts address }
end

main if __FILE__ == $PROGRAM_NAME
