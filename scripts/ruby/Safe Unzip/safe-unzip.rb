#!/usr/bin/env ruby
# frozen_string_literal: true

# Safely extracts a ZIP archive with zip-bomb and traversal protections.
#
# Requires the rubyzip gem: gem install rubyzip

require 'optparse'
require 'fileutils'

begin
  require 'zip'
rescue LoadError
  abort 'This script requires the rubyzip gem: gem install rubyzip'
end

DEFAULT_MAX_FILES = 1000
DEFAULT_MAX_BYTES = 500 * 1024 * 1024

def main
  options = parse_options
  zip_path = options[:zip_path]
  unless File.file?(zip_path)
    warn "Error: zip file not found: #{zip_path}"
    exit 1
  end

  begin
    destination = safe_unzip(zip_path, options[:max_files], options[:max_bytes])
  rescue StandardError => e
    warn "Extraction failed: #{e.message}"
    exit 1
  end
  puts "Extracted to: #{destination}"
end

def parse_options
  options = { max_files: DEFAULT_MAX_FILES, max_bytes: DEFAULT_MAX_BYTES }
  OptionParser.new do |opts|
    opts.banner = 'Usage: safe-unzip.rb ZIP [--max-file-count N] [--max-total-size BYTES]'
    opts.on('--max-file-count N', Integer, 'Maximum number of files') { |n| options[:max_files] = n }
    opts.on('--max-total-size BYTES', Integer, 'Maximum total bytes') { |n| options[:max_bytes] = n }
  end.parse!
  options[:zip_path] = ARGV[0]
  abort 'Error: provide a ZIP path.' unless options[:zip_path]
  options
end

def unsafe?(name)
  normalized = name.tr('\\', '/')
  normalized.start_with?('../') || normalized.include?('/../') || ['', '.'].include?(normalized)
end

def safe_unzip(zip_path, max_files, max_bytes)
  destination = File.join(File.dirname(File.expand_path(zip_path)), "#{File.basename(zip_path, '.*')}_unzipped")
  FileUtils.mkdir_p(destination)

  count = 0
  total = 0
  Zip::File.open(zip_path) do |archive|
    archive.each do |entry|
      raise "unsafe path detected in entry '#{entry.name}'" if unsafe?(entry.name)

      size = entry.size
      next if size.zero?

      count += 1
      total += size
      raise "file count exceeds #{max_files}" if count > max_files
      raise "total size exceeds #{max_bytes / (1024 * 1024)} MB" if total > max_bytes
    end
    archive.each { |entry| entry.extract(File.join(destination, entry.name)) { true } }
  end
  destination
end

main if __FILE__ == $PROGRAM_NAME
