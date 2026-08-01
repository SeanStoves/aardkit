# Session Log

Session logging that starts on connect and names files `log/<profile>-YYYYMMDD-HHmm`, renaming stray logs into the same scheme.

## Install

1. Download `Session Log.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `10` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `aardlog` | status: auto-start, current file, directory, format |
| `aardlog on|off` | start or stop logging this session |
| `aardlog auto on|off` | log automatically on connect |
| `aardlog list` | last 15 log files with sizes |
| `aardlog tidy` | rename stray logs into the profile scheme |

Each has its own `help` with the full list.

## Worth knowing

Per-line timestamps come from a Mudlet Host setting, not from this module. There is
no rotation, pruning or compression, and a rename that would clash is skipped rather
than overwriting.

## Config

Settings live in `<profile>/aardkit/logging.lua`.
