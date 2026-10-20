def extract_db_info(command)
  db_name = if command =~ /FROM \[(\w+)\]/
              $1
            elsif command =~ /UPDATE \[(\w+)\]/
              $1
            else
              "Unknown DB"
            end

  joins = command.scan(/JOIN \[(\w+)\]/).flatten
  join_str = joins.empty? ? "" : " with joins: [#{joins.join(', ')}]"
  "Executed DbCommand from DB [#{db_name}]#{join_str}"
end

def group_db_lines(lines)
  grouped = []
  last_info = nil
  current_lines = []

  lines.each do |line|
    num, info = line.split(' ', 2)
    if info == last_info
      current_lines << num
    else
      grouped << "#{current_lines.join(', ')} #{last_info}" unless current_lines.empty?
      current_lines = [num]
      last_info = info
    end
  end
  grouped << "#{current_lines.join(', ')} #{last_info}" unless current_lines.empty?
  grouped
end

file = ARGV[0] || "TestFile1.txt"

if File.exist?(file)
  lines = File.readlines(file)
  action_method, action, endpoint, db_lines = [], [], [], []
  current_db = ""
  start_line = nil

  lines.each_with_index do |line, i|
    num = i + 1
    case line
    when /Executed action method/
      action_method << "#{num} #{line.strip}"
    when /Executed action/
      action << "#{num} #{line.strip}"
    when /Executed endpoint/
      endpoint << "#{num} #{line.strip}"
    when /Executed DbCommand/
      db_lines << "#{start_line} #{extract_db_info(current_db)}" if current_db != ""
      current_db = line
      start_line = num
    else
      current_db += line if current_db != ""
    end
  end

  db_lines << "#{start_line} #{extract_db_info(current_db)}" if current_db != ""
  grouped_db = group_db_lines(db_lines)

  puts "\n--- Executed DbCommands ---"
  grouped_db.each { |l| puts "\e[33m#{l}\e[0m" }

  puts "\n--- Executed Action Methods ---"
  action_method.each { |l| puts "\e[33m#{l}\e[0m" }

  puts "\n--- Executed Actions ---"
  action.each { |l| puts "\e[33m#{l}\e[0m" }

  puts "\n--- Executed Endpoints ---"
  endpoint.each { |l| puts "\e[33m#{l}\e[0m" }
else
  puts "\e[31mFile not found: #{file}\e[0m"
end
