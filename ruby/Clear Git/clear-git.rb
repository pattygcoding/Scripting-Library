branches = `git branch -vv`.lines
branches.each do |line|
  unless line.match(/\[origin\//)
    branch_name = line.strip.split(/\s+/)[1]
    system("git branch -D #{branch_name}") if branch_name
  end
end
