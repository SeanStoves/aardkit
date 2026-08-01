# Info Window

Captures INFO: lines into their own panel, colours intact, and gags them from the main output.

## Install

1. Download `Info Window.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `30` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [aardcore](../aardcore/README.md) installed first at priority 1 — it holds
the shared `aard.util` / `aard.panel` / `aard.register` that every module here
builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `infowin` | |

Every one of these has its own `help`; that's the authoritative list.

## Config

Settings live in `<profile>/aard/infowindow.lua`.
