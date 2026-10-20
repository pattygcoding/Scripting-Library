local argparse = require("argparse")
local os = require("os")

-- Function to run a shell command and capture its output
local function run_command(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    local success, exit_code, exit_type = handle:close()

    if not success then
        io.stderr:write(string.format("Error: %s\n", result))
        os.exit(exit_code)
    end

    return result
end

-- Function to update Git branch
local function update_git(branch)
    print("\27[93mupdate-git: Fetching...\27[0m")
    run_command("git fetch")

    local merge_branch, message

    if branch then
        merge_branch = "origin/" .. branch
        message = string.format("Auto-merge update: Merged %s to branch using update-git Lua script (git fetch; git merge %s; git push;)", branch, merge_branch)
        print(string.format("\27[93mupdate-git: Merging %s into the current branch...\27[0m", merge_branch))
    else
        merge_branch = "origin/master"
        message = string.format("Auto-merge update: Merged master to branch using update-git Lua script (git fetch; git merge %s; git push;)", merge_branch)
        print(string.format("\27[93mupdate-git: Merging %s into the current branch...\27[0m", merge_branch))
    end

    run_command(string.format("git merge %s -m \"%s\"", merge_branch, message))

    print("\27[93mupdate-git: Pushing changes...\27[0m")
    run_command("git push")

    if branch then
        print(string.format("\27[92mupdate-git: Auto-merge complete. Your branch is now up to date with %s.\27[0m", branch))
    else
        print("\27[92mupdate-git: Auto-merge complete. Your branch is now up to date with master.\27[0m")
    end
end

-- Parse command-line arguments
local parser = argparse("update_git", "Update the current Git branch with another branch.")
parser:option("-b --branch", "The branch to merge into the current branch")

local args = parser:parse()

-- Run the update_git function with the provided branch
update_git(args.branch)
