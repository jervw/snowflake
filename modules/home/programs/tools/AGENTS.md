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
- **github** — Look up issues, pull requests, commits, and repository state
  through the GitHub MCP server instead of scraping github.com or guessing.
  Search for existing issues before creating new ones.

## Code Comments

Default to writing no comments. Most changes, especially config one-liners,
need none.

Add a comment only if a competent reader would otherwise make a mistake,
such as "removing" a workaround, "fixing" a deliberate oddity, or missing
a hidden constraint (upstream bug, ordering requirement, pinned version).

Not acceptable as comments:
- Restating what the line does or what an option means
- Where a value or file comes from, or why the change was made (put that
  in the commit message or your reply)
- Narrating the change ("Added X", "Now uses Y")

Before finishing, re-read your diff and delete any comment that fails the
test above.
