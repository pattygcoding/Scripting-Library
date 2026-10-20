require 'find'
require 'optparse'

def count_files(include_node)
  current_directory = Dir.pwd

  all_files = []
  Find.find(current_directory) do |path|
    if File.file?(path)
      next if !include_node && path.include?('node_modules')
      all_files << path
    end
  end

  total_files = all_files.size
  files_by_extension = Hash.new(0)
  
  all_files.each do |file|
    ext = File.extname(file)
    files_by_extension[ext] += 1
  end

  # Output results
  puts "\e[96mTotal number of files: \e[0m\e[93m#{total_files}\e[0m"
  puts "\e[96mFiles by extension:\e[0m"
  files_by_extension.sort.each do |ext, count|
    puts "\e[93m#{ext}: #{count}\e[0m"
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: count_files.rb [options]'

  opts.on('--includenode', 'Include files in node_modules directory') do |v|
    options[:include_node] = v
  end
end.parse!

count_files(options[:include_node])
