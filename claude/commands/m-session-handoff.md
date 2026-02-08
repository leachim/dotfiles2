---
name: session-handoff
description: Create a comprehensive handoff document for resuming work in a fresh context
allowed-tools:
  - Read
  - Write
  - Bash
  - WebSearch
  - WebFetch
---

Create a handoff document capturing all context from the current conversation. Prioritize **comprehensive detail over brevity**—enable a fresh instance to continue with zero information loss.

## Instructions

1. **Original Task**: What was initially requested (not scope creep or side tasks)

2. **Work Completed**: Everything accomplished
   - Artifacts created/modified/analyzed (files, documents, findings)
   - Specific changes (code with line numbers, content written, data analyzed)
   - Actions taken (commands, API calls, searches, tools used)
   - Discoveries and insights
   - Decisions made with reasoning

3. **Work Remaining**: Actionable steps
   - Specific tasks with precise locations/references
   - Dependencies and ordering
   - Validation steps needed

4. **Attempted Approaches**: Including failures
   - What didn't work and why
   - Errors, blockers, limitations
   - Dead ends to avoid
   - Alternatives considered but not pursued

5. **Critical Context**: Essential knowledge
   - Key decisions and trade-offs
   - Constraints and requirements
   - Gotchas, edge cases, non-obvious behaviors
   - Environment/configuration details
   - Assumptions needing validation
   - Resources consulted

6. **Relevant Files**: With descriptions
   - `path/to/file` - what it does, why it matters

7. **Current State**: Exact status
   - Deliverable status (complete/in-progress/not started)
   - Finalized vs. draft/temporary
   - Workarounds in place
   - Open questions

8. **Continuation Prompt**: Ready-to-paste prompt for new session with all necessary context

Write to `session-handoff.md` in the current working directory.

## Output Format
```markdown
## Session Handoff

### Original Task
[Precise scope of initial request]

### Work Completed
[Comprehensive list with specific references]

### Work Remaining
[Actionable steps with locations and dependencies]

### Attempted Approaches
[What was tried, what failed, why]

### Critical Context
[Decisions, gotchas, constraints, environment details]

### Relevant Files
- `path/to/file.ts` - [description]

### Current State
[What's working, broken, next]

### Continuation Prompt
\```
[Complete prompt to paste into fresh chat—include task, context, current state, and next steps]
\```
```
