# Loot Tracker

A searchable record of where items come from — which mob dropped it, which room object it was picked off, and which shops stock it and for how much — plus stat blocks read off any id or appraise box that scrolls past, with optional sync to a shared pool.

## Install

1. Download `Loot Tracker.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `60` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `loot` | |
| `bulk appraise` | |

Each has its own `help` with the full list.

## Worth knowing

It does not track sales, gold, or your inventory, and has nothing to do with goals,
quests or campaigns. `shop_stock` is what a shop natively stocks and asks for an item,
not what you sold. Gold and player-corpse loot are skipped deliberately. Identify is
mostly passive — it reads any id or appraise box that scrolls past, and only sends
`id` itself when you ask or turn `autoid` on. `loot upload` sends rows to a shared
pool and is manual.

## Config

Settings live in `<profile>/aardkit/loottracker.lua`.
