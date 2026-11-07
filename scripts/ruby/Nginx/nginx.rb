#!/usr/bin/env ruby
# frozen_string_literal: true

# Starts or reloads a local Nginx server.

require 'optparse'

# Insert the path to your nginx installation here.
NGINX_BASE = ''

def main
  options = parse_options
  base = options[:base]
  exe = File.join(base, 'nginx.exe')
  conf = File.join(base, 'conf', 'nginx.conf')

  if base.empty? || !File.file?(exe)
    warn 'Error: nginx not found. Set --base to your installation directory.'
    exit 1
  end

  if running?
    spawn(exe, '-s', 'reload', chdir: base)
  else
    spawn(exe, '-c', conf, chdir: base)
  end
end

def parse_options
  options = { base: NGINX_BASE }
  OptionParser.new do |opts|
    opts.banner = 'Usage: nginx.rb [--base DIR]'
    opts.on('--base DIR', 'Nginx installation directory') { |b| options[:base] = b }
  end.parse!
  options
end

def running?
  `tasklist /FI "IMAGENAME eq nginx.exe" 2>NUL`.include?('nginx.exe')
rescue StandardError
  false
end

main if __FILE__ == $PROGRAM_NAME
