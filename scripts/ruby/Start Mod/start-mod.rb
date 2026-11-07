#!/usr/bin/env ruby
# frozen_string_literal: true

# Builds and launches a Minecraft mod client via Gradle.

require 'optparse'

def main
  options = parse_options
  gradlew = Gem.win_platform? ? 'gradlew.bat' : './gradlew'
  system(gradlew, 'clean', 'build') unless options[:skip_build]
  system(gradlew, 'runClient')
end

def parse_options
  options = { skip_build: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: start-mod.rb [--skip-build]'
    opts.on('--skip-build', "Skip 'gradlew clean build'") { options[:skip_build] = true }
  end.parse!
  options
end

main if __FILE__ == $PROGRAM_NAME
