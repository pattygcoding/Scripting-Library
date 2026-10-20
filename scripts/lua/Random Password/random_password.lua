function generate_password(length)
    local length = length or 12
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+"
    local password = ""
    for i = 1, length do
        local randomIndex = math.random(#characters)
        password = password .. characters:sub(randomIndex, randomIndex)
    end
    return password
end

print("Generated password:", generate_password())
