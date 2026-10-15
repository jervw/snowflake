# Global Agent Instructions

## MCP Servers

Prefer an MCP server over guessing or general web search whenever one is an
authoritative source for the question.

- **mcp-nixos** — Look up NixOS options, nixpkgs packages, and Home Manager
  options before writing Nix configuration. Do not guess option names, types,
  or package attribute names.
- **context7** — Fetch current upstream documentation for libraries,
  frameworks, and tools when writing or reviewing code that depends on their
  APIs, instead of relying on memory.

## Reporting Discovered Bugs

When you notice a bug in anything you read or use, flag it to the user
clearly, even if it has nothing to do with the current task. This covers code,
configuration, documentation, tool output, and upstream dependencies.

- Raise it right away and make it easy to spot. Do not bury it in a summary or
  quietly work around it.
- Say where it is (file and line, command, or source), what is wrong, and why
  it matters.
- Do not fix bugs outside the scope of the task without asking. Report them
  and let the user decide.
