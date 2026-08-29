# coyote-bundle-template

A starter template for [Coyote](https://github.com/Dark-Alex-17/coyote)
bundles: shareable configurations distributed via any Git repository.
Repositories structured like this let users share agents, roles, skills,
macros, tools, and MCP servers in Coyote easily. Bundles are Coyote's
equivalent of plugins.

Fork this repo, customize the assets to your taste, then install your fork
into Coyote with a single command.

## Quick start

Install everything in this template into your local Coyote config using the
`owner/repo` shorthand (expanded against github.com by default):

```sh
coyote --install <you>/coyote-bundle-template
```

or with a full Git URL, or from within the Coyote REPL:

```sh
coyote --install https://github.com/<you>/coyote-bundle-template
```

```
.install <you>/coyote-bundle-template
```

Hosting somewhere other than GitHub? Point the shorthand at your forge:

```sh
coyote --install <group>/<subgroup>/coyote-bundle-template --git-host gitlab.com
```

Pin to a specific branch, tag, or commit by suffixing `#<ref>`:

```sh
coyote --install <you>/coyote-bundle-template#v1.0.0
coyote --install <you>/coyote-bundle-template#main
coyote --install <you>/coyote-bundle-template#abc1234
```

Restrict the install to a single asset category with `--filter`:

```sh
coyote --install <you>/coyote-bundle-template --filter agents
coyote --install <you>/coyote-bundle-template --filter mcp-config
```

Valid filter values: `agents`, `roles`, `skills`, `macros`, `functions`, `mcp-config`.

Skip per-file conflict prompts with `--install-force`:

```sh
coyote --install <you>/coyote-bundle-template --install-force
```

## Managing the installed bundle

Coyote records everything a bundle install writes (file paths, MCP server
entries, and content hashes) in a provenance store, which powers the full
lifecycle:

```sh
coyote --list-bundles                          # name, version, source, drift
coyote --install <bundle-name>                 # update by installed name
coyote --update-bundle <bundle-name>           # update from the recorded source
coyote --update-bundle <bundle-name>#<ref>     # move a pin while updating
coyote --update-bundle <bundle-name> --yes     # non-interactive: keep local edits, refresh the rest
coyote --uninstall <bundle-name>               # remove owned files and MCP entries
coyote --uninstall <bundle-name> --yes         # skip the confirmation prompt
```

The same operations are available in the REPL as `.list bundles`,
`.install <bundle-name>`, and `.uninstall <bundle-name> [--yes]`.

Updates and uninstalls never clobber your local edits: files you modified
after install are prompted for (and kept by default on uninstall), while
untouched files refresh or delete silently. See the
[Sharing Configurations wiki](https://github.com/Dark-Alex-17/coyote/wiki/Sharing-Configurations)
for the full ownership and drift model.

## The manifest (`coyote-bundle.yaml`)

The optional manifest at the repo root declares the bundle's identity, and
nothing else. Coyote discovers installable content by scanning the asset
directories; the manifest never lists files.

```yaml
name: coyote-bundle-template
version: "1.0.0"
description: Starter template for Coyote bundles
homepage: https://github.com/Dark-Alex-17/coyote-bundle-template
```

- `name` is how consumers refer to the bundle in `--update-bundle` and
  `--uninstall`. Ship a manifest so your bundle keeps a stable name across
  forks; without one, Coyote derives the name from the repository name.
- `version` shows up in `--list-bundles` (falls back to the short commit SHA).
- If your chosen name collides with another installed bundle or a built-in
  asset category, Coyote qualifies it with the repo owner (`owner/name`)
  instead of overwriting anything.

## Layout

Coyote only reads the manifest and these top-level directories. Anything
else in the repo is ignored.

```
coyote-bundle-template/
├── coyote-bundle.yaml             # Optional identity manifest
├── agents/
│   └── <agent-name>/
│       ├── config.yaml            # LLM-loop agent
│       │   └── (or graph.yaml)    # Graph agent
│       ├── README.md              # Optional
│       ├── tools.sh               # Optional agent-local tools
│       └── scripts/               # Optional graph-node scripts
├── roles/
│   └── <role-name>.md             # Role with frontmatter + prompt body
├── skills/
│   └── <skill-name>/
│       └── SKILL.md               # Skill with frontmatter + body
├── macros/
│   └── <macro-name>.yaml          # Positional/rest-args + REPL command steps
└── functions/
    ├── tools/
    │   └── *.sh / *.py / *.ts     # Global tools (auto chmod +x on install)
    └── mcp.json                   # MCP server config (merged with local)
```

The `functions/mcp.json` file is **merged** into your existing local file
on install (not overwritten). For conflicting server names, you'll be
prompted to keep yours, take the remote's, or rename the remote entry.
On update, entries the bundle installed and you never edited take the
remote side automatically.

## What's in this template

| Asset | File                             | What it is                                              |
|-------|----------------------------------|---------------------------------------------------------|
| Agent | `agents/hello-agent/config.yaml` | Tiny LLM-loop agent that greets the user.               |
| Role  | `roles/explainer.md`             | Role that explains technical concepts simply.           |
| Skill | `skills/rust-fmt/SKILL.md`       | Skill demonstrating `enabled_tools` + `auto_unload`.    |
| Macro | `macros/greet.yaml`              | Macro showing positional and rest-arg variables.        |
| Tool  | `functions/tools/greet.sh`       | Bash tool using Coyote's argc-style annotations.        |
| MCP   | `functions/mcp.json`             | One vanilla server + one with a vault secret reference. |

Each sample is intentionally minimal. Replace it with your own work, or
delete what you don't need.

## Customizing

### Agents
Each agent lives in its own subdirectory under `agents/`. For LLM-loop
agents, put a `config.yaml` (full schema:
[Agents wiki](https://github.com/Dark-Alex-17/coyote/wiki/Agents)). For
declarative graph agents, put a `graph.yaml` instead
([Graph Agents wiki](https://github.com/Dark-Alex-17/coyote/wiki/Graph-Agents)).

### Roles
Each `roles/<name>.md` is a YAML frontmatter block followed by the role
instructions ([Roles wiki](https://github.com/Dark-Alex-17/coyote/wiki/Roles)).

### Skills
Each skill lives in its own subdirectory under `skills/`, with a
`SKILL.md` file containing YAML frontmatter (`description`,
`enabled_tools`, `enabled_mcp_servers`, `auto_unload`) followed by a
body of instructions that get injected into the model's system prompt
while the skill is loaded
([Skills wiki](https://github.com/Dark-Alex-17/coyote/wiki/Skills)).

### Macros
Each `macros/<name>.yaml` is a list of REPL commands to execute, with
optional positional/rest variables
([Macros wiki](https://github.com/Dark-Alex-17/coyote/wiki/Macros)).

### Tools
Tools in `functions/tools/` follow Coyote's argc-style schema
([Custom Tools wiki](https://github.com/Dark-Alex-17/coyote/wiki/Custom-Tools)).
Bash, Python, and TypeScript scripts are auto-detected and given the
executable bit on install.

### MCP servers
Add or modify entries in `functions/mcp.json`
([MCP Servers wiki](https://github.com/Dark-Alex-17/coyote/wiki/MCP-Servers)).
Use `{{SECRET_NAME}}` placeholders for values you don't want to commit;
Coyote will detect missing secrets after the merge and prompt you to add
them to the vault (or list them for you to add via `coyote --add-secret`).

### (Optional) Sandbox mixins (`sbx-mixin.yaml`)
If consumers of your bundle run Coyote in [Sandbox mode](https://github.com/Dark-Alex-17/coyote/wiki/Sandboxes),
they'll need any external binaries and network domain allowances declared
in an `sbx-mixin.yaml` file. Coyote auto-discovers mixin files at known
locations on every `coyote --sandbox` invocation, no flags required.

This template ships two starter examples:

- **`agents/hello-agent/sbx-mixin.yaml`:** Per-agent mixin, applied when
  the agent is installed and any `coyote --sandbox` runs.
- **`functions/sbx-mixin.yaml`:** Shared by all custom tools in this
  bundle. For per-tool granularity, use `functions/<tool>/sbx-mixin.yaml`
  instead.

Both starters are commented-out templates. Simply open them and fill in the
domains and install commands your assets actually need. Delete the files
if they're not needed.

> ⚠️ **Privilege grant.** Anyone installing your bundle is granting the
> mixins' install commands (passwordless sudo) and network domain
> allowances inside their sandboxes. Document any non-obvious entries in
> this README so they don't have to grep your YAML to find out what
> they're accepting. See the [Sharing Configurations - Sandbox Implications](https://github.com/Dark-Alex-17/coyote/wiki/Sharing-Configurations#sandbox-implications)
> wiki page for the full security model.

## Secrets workflow

Anywhere you reference a secret in `mcp.json` (or in any installed file),
use the `{{NAME}}` placeholder syntax. After an install completes:

- **Interactive mode**: Coyote prompts you per-secret to add the value to
  the vault. On the first "Yes," it creates the vault password file if
  needed.
- **Non-interactive mode** (CI, piped): Coyote prints a final reminder
  listing every missing secret with the `coyote --add-secret <NAME>` /
  `.vault add <NAME>` commands you can run to fill them in.

See the [Vault wiki](https://github.com/Dark-Alex-17/coyote/wiki/Vault) for
the full secrets workflow.

## Tips for forks

- Ship a `coyote-bundle.yaml` with your own `name` so your bundle keeps a
  stable identity no matter what consumers or forks call the repository.
- Pin your fork to tagged releases so consumers can install with
  `#<tag>` for reproducibility, and bump the manifest `version` alongside
  your tags so `coyote --list-bundles` shows something meaningful.
- Keep agent-local logic in `agents/<name>/scripts/`. Global
  tools (in `functions/tools/`) are shared across every agent.
- Removing a file from your fork does propagate: on the next
  `--update-bundle`, consumers are asked whether to keep or delete files
  the bundle no longer ships. Removing an `mcp.json` server does not prune
  existing installs of that entry; uninstalling the bundle removes the
  entries it added (unless the user edited them).
