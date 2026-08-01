# Loot Tracker

A searchable database of everything you have looted, identified and sold.

## Install

1. Download `Loot Tracker.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `60` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [aardcore](../aardcore/README.md) installed first at priority 1 — it holds
the shared `aard.util` / `aard.panel` / `aard.register` that every module here
builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `loot` | |
| `bulk appraise` | |

Every one of these has its own `help`; that's the authoritative list.

## Config

Settings live in `<profile>/aard/loottracker.lua`.
