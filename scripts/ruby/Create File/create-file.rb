#!/usr/bin/env ruby
# frozen_string_literal: true

# Creates a new file, defaulting to a .txt extension.

require 'fileutils'

name = ARGV[0]
abort 'Usage: create-file.rb NAME' if name.nil? || name.empty?

name += '.txt' if File.extname(name).empty?
FileUtils.touch(name)
puts "Created #{name}"
