# loki-config-template

A starter template for sharing [Loki](https://github.com/Dark-Alex-17/loki)
configurations via any Git repository. Repositories structured like this enable
users to share agents, roles, macros, tools, and MCP servers in Loki easily.

Fork this repo, customize the assets to your taste, then install your fork
into Loki with a single command.

## Quick start

Install everything in this template into your local Loki config:

```sh
loki --install-from https://github.com/<you>/loki-config-template
```

or from within the Loki REPL:

```
.install remote https://github.com/<you>/loki-config-template
```

Pin to a specific branch, tag, or commit by suffixing `#<ref>`:

```sh
loki --install-from https://github.com/<you>/loki-config-template#v1.0.0
loki --install-from https://github.com/<you>/loki-config-template#main
loki --install-from https://github.com/<you>/loki-config-template#abc1234
```

Restrict the install to a single asset category with `--filter`:

```sh
loki --install-from https://github.com/<you>/loki-config-template --filter agents
loki --install-from https://github.com/<you>/loki-config-template --filter mcp_config
```

Valid filter values: `agents`, `roles`, `macros`, `functions`, `mcp_config`.

Skip per-file conflict prompts with `--install-force`:

```sh
loki --install-from https://github.com/<you>/loki-config-template --install-force
```

## Layout

Loki only reads these top-level directories. Anything else in the repo is
ignored.

```
loki-config-template/
├── agents/
│   └── <agent-name>/
│       ├── config.yaml            # LLM-loop agent
│       │   └── (or graph.yaml)    # Graph agent
│       ├── README.md              # Optional
│       ├── tools.sh               # Optional agent-local tools
│       └── scripts/               # Optional graph-node scripts
├── roles/
│   └── <role-name>.md             # Role with frontmatter + prompt body
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

## What's in this template

| Asset  | File                              | What it is                                              |
|--------|-----------------------------------|---------------------------------------------------------|
| Agent  | `agents/hello-agent/config.yaml`  | Tiny LLM-loop agent that greets the user.               |
| Role   | `roles/explainer.md`              | Role that explains technical concepts simply.           |
| Macro  | `macros/greet.yaml`               | Macro showing positional and rest-arg variables.        |
| Tool   | `functions/tools/greet.sh`        | Bash tool using Loki's argc-style annotations.          |
| MCP    | `functions/mcp.json`              | One vanilla server + one with a vault secret reference. |

Each sample is intentionally minimal. Replace it with your own work, or
delete what you don't need.

## Customizing

### Agents
Each agent lives in its own subdirectory under `agents/`. For LLM-loop
agents, put a `config.yaml` (full schema:
[Agents wiki](https://github.com/Dark-Alex-17/loki/wiki/Agents)). For
declarative graph agents, put a `graph.yaml` instead
([Graph Agents wiki](https://github.com/Dark-Alex-17/loki/wiki/Graph-Agents)).

### Roles
Each `roles/<name>.md` is a YAML frontmatter block followed by the role
instructions ([Roles wiki](https://github.com/Dark-Alex-17/loki/wiki/Roles)).

### Macros
Each `macros/<name>.yaml` is a list of REPL commands to execute, with
optional positional/rest variables
([Macros wiki](https://github.com/Dark-Alex-17/loki/wiki/Macros)).

### Tools
Tools in `functions/tools/` follow Loki's argc-style schema
([Custom Tools wiki](https://github.com/Dark-Alex-17/loki/wiki/Custom-Tools)).
Bash, Python, and TypeScript scripts are auto-detected and given the
executable bit on install.

### MCP servers
Add or modify entries in `functions/mcp.json`
([MCP Servers wiki](https://github.com/Dark-Alex-17/loki/wiki/MCP-Servers)).
Use `{{SECRET_NAME}}` placeholders for values you don't want to commit;
Loki will detect missing secrets after the merge and prompt you to add
them to the vault (or list them for you to add via `loki --add-secret`).

## Secrets workflow

Anywhere you reference a secret in `mcp.json` (or in any installed file),
use the `{{NAME}}` placeholder syntax. After `--install-from` completes:

- **Interactive mode**: Loki prompts you per-secret to add the value to
  the vault. On the first "Yes," it creates the vault password file if
  needed.
- **Non-interactive mode** (CI, piped): Loki prints a final reminder
  listing every missing secret with the `loki --add-secret <NAME>` /
  `.vault add <NAME>` commands you can run to fill them in.

See the [Vault wiki](https://github.com/Dark-Alex-17/loki/wiki/Vault) for
the full secrets workflow.

## Tips for forks

- Pin your fork to tagged releases so consumers can install with
  `#<tag>` for reproducibility.
- Keep agent-local logic in `agents/<name>/scripts/`. Global
  tools (in `functions/tools/`) are shared across every agent.
- The `mcp.json` merge is *additive*. If you remove a server from your
  fork, existing installs of that server are _not_ pruned. That's by design.
