#!/usr/bin/env ruby
# frozen_string_literal: true

# Searches files of a given extension for one or more terms.

require 'optparse'
require 'find'

MAX_RESULTS = 3000

def main
  options = parse_options
  search(options)
end

def parse_options
  options = { uncapped: false, cross: false, dir: false, calls: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: search-match.rb EXTENSION TERM [TERM...] [options]'
    opts.on('--uncapped', 'List more than the limit of 3000 results') { options[:uncapped] = true }
    opts.on('--cross', 'Only search files that have all of the terms') { options[:cross] = true }
    opts.on('--dir', 'Display full file paths, not just file names') { options[:dir] = true }
    opts.on('--calls', 'Only match when a period precedes the term') { options[:calls] = true }
  end.parse!
  options[:extension] = ARGV[0]
  options[:terms] = ARGV[1..] || []
  abort 'Usage: search-match.rb EXTENSION TERM [TERM...]' if options[:extension].nil? || options[:terms].empty?
  options
end

def search(options)
  extension = options[:extension]
  extension = ".#{extension}" unless extension.start_with?('.')
  terms = options[:terms]
  results = 0
  cap = false

  files = []
  Find.find('.') do |path|
    files << path if File.file?(path) && path.end_with?(extension)
  end

  files.each do |file|
    break if cap

    printed = false
    skip_using = extension == '.cs'
    active = !skip_using
    term_matches = Hash.new { |hash, key| hash[key] = [] }

    begin
      File.foreach(file).with_index(1) do |line, number|
        if skip_using && line.strip.start_with?('using ')
          next
        elsif skip_using
          active = true
          skip_using = false
        end
        next unless active

        terms.each do |term|
          escaped = Regexp.escape(term)
          next unless line =~ /#{escaped}/
          next if options[:calls] && line !~ /\.#{escaped}/

          if options[:cross]
            term_matches[term] << [number, line]
            next
          end

          unless printed
            puts options[:dir] ? file : File.basename(file)
            printed = true
          end
          puts "#{number}\t#{line.strip}"
          results += 1
          if !options[:uncapped] && results >= MAX_RESULTS
            cap = true
            break
          end
        end
        break if cap
      end
    rescue SystemCallError => e
      warn "An error occurred while processing #{file}: #{e.message}"
      next
    end

    next unless options[:cross] && term_matches.size == terms.size

    puts options[:dir] ? file : File.basename(file)
    term_matches.each_value do |matches|
      matches.each { |number, content| puts "#{number}\t#{content.strip}" }
    end
    results += 1
    cap = true if !options[:uncapped] && results >= MAX_RESULTS
  end
end

main if __FILE__ == $PROGRAM_NAME
