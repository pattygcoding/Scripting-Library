def generate_password(length = 12)
  characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+']
  password = Array.new(length) { characters.sample }.join
end

puts "Generated password: #{generate_password}"
