# Loot Tracker

A searchable record of where items come from — which mob dropped it, which room object it was picked off, and which shops stock it and for how much — plus stat blocks read off any id or appraise box that scrolls past, with optional sync to a shared pool.

## Install

1. Download `Loot Tracker.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `60` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `loot` | |
| `bulk appraise` | |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/solao/loottracker.lua`.
