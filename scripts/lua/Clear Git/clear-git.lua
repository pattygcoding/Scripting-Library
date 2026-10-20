local handle = io.popen("git branch -vv")
local output = handle:read("*a")
handle:close()

for line in output:gmatch("[^\r\n]+") do
  if not line:match("%[origin/") then
    local branch = line:gsub("^%*", ""):match("^%s*(%S+)")
    if branch then
      os.execute("git branch -D " .. branch)
    end
  end
end
