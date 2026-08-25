---
description: "Prepare changes for PR with agent-pr-focus-taskmaster"
---

# PR Preparation Command

Invokes the agent-pr-focus-taskmaster to prepare changes for a pull request with comprehensive verification and messaging.

**Usage**: `/pr-prepare`

**What it does**:
This command automatically invokes the agent-pr-focus-taskmaster agent to:
1. Verify that everything works properly
2. Prepare a strong commit title
3. Create a comprehensive PR message body with:
   - Good TL;DR summary of changes
   - WHY: Clear explanation of the motivation
   - WHAT: Description of what was changed
   - HOW: Explanation of the implementation approach

**IMPORTANT WARNING**: Beware of running git diff with no size limits. That blows the LLM context. Always use appropriate git diff options with size limits when analyzing changes.

**Arguments**: $ARGUMENTS

@agent-pr-focus-taskmaster can you prep these changes for the PR? Verify everything works. Prepare a strong commit title, and a strong PR message body that provides a good tl;dr on the changes, and has WHY, WHAT, HOW clearly identified