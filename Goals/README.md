# Goals

Savings targets against the six currencies in `gmcp.char.worth` — qp, tp, gold, bank, trains, pracs — announced once the moment one is met, to your screen or a MUD channel.

## Install

1. Download `Goals.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `80` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `goal` | progress bars for all goals, closest first |
| `goal add <name> <amt> [type]` | save or update a goal |
| `goal rm <name>` | delete one |
| `goal <type>` | filter to qp/tp/gold/bank/trains/pracs |
| `goal report` | send nearest unfinished goal to the channel |
| `goal channel <name|echo>` | where announcements go |
| `goal worth` | current holdings from gmcp.char.worth |
| `goal clear yes` | delete every goal |

Each has its own `help` with the full list.

## Worth knowing

These are savings targets against your own currencies. Nothing to do with Aardwolf's
quests or campaigns, and it doesn't track spending or history.

## Config

Settings live in `<profile>/aardkit/goals.lua`.
