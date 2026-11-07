#!/usr/bin/env ruby
# frozen_string_literal: true

# Builds and updates an index of .cs files under a directory tree.

require 'optparse'
require 'find'
require 'set'

CYAN = "\e[36m"
GREEN = "\e[32m"
RESET = "\e[0m"

def main
  options = parse_options
  added, removed, changed = update_index(options[:root], options[:index_file])
  if added + removed + changed == 0
    puts "#{GREEN}No changes detected in .cs files under '#{options[:root]}'.#{RESET}"
  else
    puts "#{CYAN}Index updated: +#{added} / -#{removed} / *#{changed}#{RESET}"
  end
end

def parse_options
  options = { root: '.' }
  OptionParser.new do |opts|
    opts.banner = 'Usage: cache-vsindex.rb --index-file FILE [--root DIR]'
    opts.on('--root DIR', 'Root directory to scan (default: current)') { |r| options[:root] = r }
    opts.on('--index-file FILE', 'Path to the index file (required)') { |f| options[:index_file] = f }
  end.parse!
  abort 'Error: --index-file is required.' unless options[:index_file]
  options
end

def read_index(index_file)
  index = {}
  return index unless File.exist?(index_file)

  File.foreach(index_file) do |line|
    next unless line.include?('|')

    name, dirs = line.chomp.split('|', 2)
    index[name] = dirs.split(';').reject(&:empty?).to_set
  end
  index
end

def scan(root)
  index = Hash.new { |hash, key| hash[key] = Set.new }
  Find.find(root) do |path|
    next unless File.file?(path) && path.downcase.end_with?('.cs')

    index[File.basename(path, '.cs')] << File.dirname(path)
  end
  index
end

def update_index(root, index_file)
  old = read_index(index_file)
  new = scan(root)
  added = new.keys - old.keys
  removed = old.keys - new.keys
  changed = (new.keys & old.keys).select { |key| new[key] != old[key] }

  merged = old.reject { |key, _| removed.include?(key) || changed.include?(key) }
  (added + changed).each { |key| merged[key] = new[key] }

  File.open(index_file, 'w') do |file|
    merged.keys.sort.each { |key| file.puts "#{key}|#{merged[key].to_a.sort.join(';')}" }
  end
  [added.size, removed.size, changed.size]
end

main if __FILE__ == $PROGRAM_NAME
