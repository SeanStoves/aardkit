# Recall Manager

Clickable command buttons you define yourself — each fires a `|`-separated list of commands with `$var` substitution, tracks a use count, and can watch for an arrival line to show where you are. The grid reflows and scrolls as you resize the panel.

## Install

1. Download `Recall Manager.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `40` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `recallmanager` | show/hide the panel |
| `rm <name>` | fire that button's commands |
| `recallmanager add <name> <cmd|cmd>` | create a button |
| `recallmanager edit <name> <cmd|cmd>` | replace its commands |
| `recallmanager del <name>` | remove a button and its trigger |
| `recallmanager at <name> <regex|off>` | arrival line that sets the At: field |
| `recallmanager var <name> <value|off>` | define $name used inside commands |
| `recallmanager vars` | list defined vars |
| `recallmanager list` | print buttons, commands, counters |
| `recallmanager reset` | zero the use counters |
| `recallmanager factoryreset confirm` | wipe all buttons and vars |
| `recallmanager show|hide|dock|embed` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/recallmanager.lua`.
