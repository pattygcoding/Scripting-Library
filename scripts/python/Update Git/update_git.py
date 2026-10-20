import subprocess
import argparse

def run_command(command):
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    if result.returncode != 0:
        print(f"Error: {result.stderr}")
        exit(result.returncode)
    return result.stdout

def update_git(branch=None):
    print("\033[93mupdate-git: Fetching...\033[0m")
    run_command("git fetch")

    if branch:
        merge_branch = f"origin/{branch}"
        message = f"Auto-merge update: Merged {branch} to branch using update-git Python script (git fetch; git merge {merge_branch}; git push;)"
        print(f"\033[93mupdate-git: Merging {merge_branch} into the current branch...\033[0m")
    else:
        merge_branch = "origin/master"
        message = f"Auto-merge update: Merged master to branch using update-git Python script (git fetch; git merge {merge_branch}; git push;)"
        print(f"\033[93mupdate-git: Merging {merge_branch} into the current branch...\033[0m")

    run_command(f"git merge {merge_branch} -m \"{message}\"")

    print("\033[93mupdate-git: Pushing changes...\033[0m")
    run_command("git push")

    if branch:
        print(f"\033[92mupdate-git: Auto-merge complete. Your branch is now up to date with {branch}.\033[0m")
    else:
        print(f"\033[92mupdate-git: Auto-merge complete. Your branch is now up to date with master.\033[0m")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Update the current Git branch with another branch.")
    parser.add_argument("-branch", type=str, help="The branch to merge into the current branch")
    args = parser.parse_args()

    update_git(args.branch)
