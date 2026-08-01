# ASCII Map

The MUD's own ASCII map in a panel of its own.

## Install

1. Download `ASCII Map.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `26` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [aardcore](../aardcore/README.md) installed first at priority 1 — it holds
the shared `aard.util` / `aard.panel` / `aard.register` that every module here
builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `asciimap` | |

Every one of these has its own `help`; that's the authoritative list.

## Config

Settings live in `<profile>/aard/asciimap.lua`.
