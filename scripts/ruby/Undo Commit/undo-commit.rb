mode = ARGV[0] || "hard"
valid_modes = ["hard", "mixed", "soft"]

unless valid_modes.include?(mode)
  puts "\e[31mInvalid mode specified. Use 'hard', 'mixed', or 'soft'.\e[0m"
  exit 1
end

puts "\e[33mundo-commit: Undoing the last commit...\e[0m"
system("git reset --#{mode} HEAD~1")

puts "\e[33mundo-commit: Pushing changes...\e[0m"
system("git push --force")

puts "\e[32mundo-commit: Undo last commit complete.\e[0m"
