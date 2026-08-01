# Player Tracker

Keeps a record of everyone your `who` sweeps see — clan, level/race/class, title and last-seen — searchable by name, title or clan.

## Install

1. Download `Player Tracker.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `50` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `pt` | show/hide the panel |
| `pt find <text>` | search name, title and clan across all records |
| `pt filter <text>` | filter the panel list, blank clears |
| `pt info <name>` | full record for one player |
| `pt online` | list who counted as online |
| `pt count` | tracked, online, average per sweep |
| `pt export` | write players.csv |
| `pt clear yes` | wipe the database |
| `pt dock|embed` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/solao/playertracker.lua`.
