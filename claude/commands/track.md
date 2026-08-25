---
description: Time tracking command for managing tasks across Claude Code instances
allowed-tools: 
  - "mcp__toggl__tt_start_task"
  - "mcp__toggl__tt_stop_task"
  - "mcp__toggl__tt_get_status"
  - "mcp__toggl__tt_switch_task"
  - "Bash(TOGGL_API_TOKEN=*)"
---

# Time Tracking Command

You are helping the user manage time tracking for their current task. Parse the arguments to understand what action they want to take:

**Arguments:** $ARGUMENTS

## Available Actions:

### **start** or **s** - Start a new task
Usage: `/track start "Task description"` or `/track start "Task description" --project-id 123 --tags "tag1,tag2"`

### **stop** or **x** - Stop the current task  
Usage: `/track stop`

### **status** or **st** - Show current task status
Usage: `/track status` or `/track status --verbose`

### **switch** or **sw** - Switch to a new task (stops current, starts new)
Usage: `/track switch "New task description"`

### **help** or **h** - Show help
Usage: `/track help`

## Instructions:

1. **Parse the arguments** to determine the action and parameters
2. **Use the appropriate MCP tool** from the time tracker:
   - `mcp__toggl__tt_start_task` for starting tasks
   - `mcp__toggl__tt_stop_task` for stopping tasks  
   - `mcp__toggl__tt_get_status` for status checks
   - `mcp__toggl__tt_switch_task` for switching tasks
3. **If MCP tools are not available**, fall back to the CLI using: `TOGGL_API_TOKEN=<token> npm run tt <command>` from the toggl-mcp-server directory
4. **Provide clear feedback** about what happened (started, stopped, current status, etc.)
5. **Keep responses concise** - just report the action taken and current status

## Examples:

- `/track start "Working on MCP integration"` → Start tracking this task
- `/track switch "Code review"` → Switch to code review task  
- `/track status` → Show what's currently being tracked
- `/track stop` → Stop current timer

**Always be concise and focus on the tracking action requested.**