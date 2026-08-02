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
| `loot` | row counts |
| `loot item <text>` | where an item drops from (mob / zone / room) |
| `loot mob <text>` | what a mob drops |
| `loot shop <text>` | which shops natively stock an item |
| `loot gathered <text>` | where a room resource is picked up |
| `loot stats <text>` | stat block for an item |
| `loot id <keyword>` | identify an item and store its stats |
| `loot autoid on\|off` | auto-identify freshly looted gear |
| `loot idnote on\|off` | confirm each stat capture on screen |
| `loot here <keyword>` | get a room-floor spawn and record it |
| `loot del <item> [roomid]` | remove matching rows |
| `inv` | reads invdata instead, so containers are learned by type — rename-proof |
| `loot inv on\|off` | intercept 'inv', or hand it straight to the MUD |
| `loot bags [add\|del <word>]` | container words ignored for gathers (the fallback) |
| `loot flags [add\|del <word>]` | bonus-loot flags stripped from names |
| `loot dedupe` | collapse variant rows already captured |
| `appraise <a>-<b>` | appraise a range of shop list numbers, paced |
| `loot appraise stop` | halt a running bulk appraise |
| `loot recent` | last 15 things looted |
| `loot export [file]` | dump the DB to a file to share |
| `loot import <file>` | merge a shared export |
| `loot api` | the shared pool: endpoint, who you are, what is unsynced |
| `loot auth` | register this character with the pool |
| `loot upload` | push what is new since last time |
| `loot update` | pull the pool into your database |
| `loot resync yes` | re-send everything on the next upload |
| `loot clear loot\|shop\|gathered\|stats` | wipe a table — writes a backup first |
| `loot restore [table]` | list clear-time backups, or put the newest back |

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
