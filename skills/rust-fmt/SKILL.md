---
description: Run rustfmt and cargo check before finalizing Rust edits. Grants shell access and auto-unloads after the model finishes.
enabled_tools: execute_command
auto_unload: true
---
You are finalizing edits to a Rust codebase. Before declaring the work complete, ALWAYS run the formatter and a check
build using the `execute_command` tool.

## Workflow

1. After making edits, run `cargo fmt` to normalize formatting.
2. Run `cargo check` to surface compilation errors quickly (faster than `cargo build`).
3. If `cargo check` fails, read the errors and fix before reporting completion.
4. Only after both succeed, summarize the change.

## Why this skill auto-unloads

`auto_unload: true` in the frontmatter means this skill removes itself from the registry after the model produces a
final response (no more tool calls). The user's next message starts with a clean context — the next prompt won't have
"run rustfmt" guidance polluting unrelated discussions.

Reload it explicitly via `.skill load rust-fmt` (or the model can `skill__load` it) when working on Rust again.
