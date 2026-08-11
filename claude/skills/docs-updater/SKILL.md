---
name: docs-updater
description: Documentation maintainer. Trigger this when code logic changes to ensure READMEs, docstrings, and comments remain accurate.
---

# Documentation Sync Protocol

## Instructions
When code logic is modified:
1. **Docstrings**: Update the function/class docstring immediately. If arguments changed, update type hints and descriptions.
2. **README**: If setup steps or env vars changed, generate a diff for the `README.md`.
3. **Comments**: Delete comments that are no longer true. (Stale comments are worse than no comments).

## Output Format
Always present documentation changes as a separate code block or file diff so they are easy to commit.

