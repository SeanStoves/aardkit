# Player Tracker

Keeps a record of everyone your `who` sweeps see — clan, level/race/class, title and last-seen — searchable by name, title or clan.

It also reads a 'finger' block when one scrolls past. It never sends one: finger is slow and answers about a single player, which is the reason this sweeps 'who' instead. What it takes is the part who cannot give — the real level, the spelled-out race and class, the tier, the remort chain and the clan by name. Email, web address and 'is from' are deliberately not kept.

## Install

1. Download `Player Tracker.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `50` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `pt opacity <0-255>` | how solid this window is; 'default' follows the shared setting |
| `pt` | this list |
| `pt toggle` | show or hide the panel |
| `pt find <text>` | search name, title and clan across all records |
| `pt filter <text>` | filter the panel list, blank clears |
| `pt info <name>` | full record for one player |
| `pt online` | list who counted as online |
| `pt count` | tracked, online, average per sweep |
| `pt export` | write players.csv |
| `pt clear yes` | wipe the database |
| `pt dock\|embed` | panel placement |

Each has its own `help` with the full list.

## Worth knowing

It only learns from `who` output, so records are as fresh as your last sweep — pair it
with Who Poller if you want that automatic. Online means "appeared in the most recent
sweep", not a live status. Clan detection is a fixed list of decorations; anything else
records with a blank clan.

## Config

Settings live in `<profile>/aardkit/playertracker.lua`.
