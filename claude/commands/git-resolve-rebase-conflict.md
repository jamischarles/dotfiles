# Git Resolve Rebase Conflict

We are currently in a git rebase (with conflicts). Here's how I want you to resolve it.

For any changes that are "formatting/linting/type error" related, choose "theirs". Ask me about any changes that don't fall into that category.

## Process:
1. Check git status to see conflicted files
2. For each conflicted file, examine the differences 
3. For formatting/linting/type changes: automatically choose "theirs" (incoming changes)
4. For functional/logic changes: ask the user for guidance
5. Mark files as resolved and continue the rebase

## Implementation:
- Use `git diff <file>` to examine conflicts
- Use `git checkout --theirs <file>` for formatting conflicts
- Use `git add <file>` to mark resolution
- Continue with `git rebase --continue` when all conflicts resolved