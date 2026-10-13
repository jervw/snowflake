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
