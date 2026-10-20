function rebase_git(branch)
    print("\27[33mrebase-git: Fetching latest changes...\27[0m")
    os.execute("git fetch")

    local rebase_branch = branch and ("origin/" .. branch) or "origin/master"
    print("\27[33mrebase-git: Rebasing onto " .. rebase_branch .. "...\27[0m")

    local success = os.execute("git rebase " .. rebase_branch)
    if success ~= 0 then
        print("\27[31mrebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.\27[0m")
        return
    end

    print("\27[33mrebase-git: Rebase successful. Pushing rebased changes...\27[0m")
    os.execute("git push --force-with-lease")

    if branch then
        print("\27[32mrebase-git: Rebase complete. Your branch is now up to date with " .. branch .. " (no merge commit).\27[0m")
    else
        print("\27[32mrebase-git: Rebase complete. Your branch is now up to date with master (no merge commit).\27[0m")
    end
end

rebase_git(arg[1])
