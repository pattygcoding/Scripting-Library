## Clear Git
This script deletes all local branches that are not currently published. I like to use this branch because there is a Visual Studio bug that sometimes causes many past branches to locally respawn upon rebooting the app, causing unwanted clutter.

**NOTE:** You should not use this command if you don't regularly push your changes. I almost always push my commits immediately after creating them, so this is practical for me, but if you have unpublished branches with many commits, don't use this command until you publish them (or else you will lose your branch). Also, this command will not delete any branches you are currently checked out on.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- None.

### Example Usage
```powershell
Clear-Git
```