# Clan Shops

The sixty clan shop rooms, as a table you can read, with a [go] on each that walks you there. The room list is the stock AardwolfMudlet module's own — its ClanShops hover menu holds the same sixty — but every entry there calls gotoRoom(), a function that module calls seventeen times and defines nowhere, so those have been dead a while.

Stock comes from Loot Tracker when it is installed, because that module already records shop_stock keyed by roomid for every shop on Aardwolf and two modules writing one fact is how they drift apart. Without it, this keeps its own from the same 'list' output — for these sixty rooms only.

## Install

1. Download `Clan Shops.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `29` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `clanshops` | all sixty, with a [go] on each |
| `clanshops <clan>` | one clan — 'clanshops tao' |
| `clanshops find <item>` | which clan shop stocks it |
| `clanshops forget` | drop the stock this module learned itself |

Each has its own `help` with the full list.

## Worth knowing

Stock has one owner. With Loot Tracker installed this reads its table and records
nothing of its own; without it, it learns from 'list' as you visit — and only in the sixty
rooms, because this is a clan shop command and has no business remembering the whole game.

'clanshops forget' clears what this module learned. With Loot Tracker present it will tell you
to use 'loot clear shop' instead, since the record is not its to clear.

## Config

Settings live in `<profile>/aardkit/clanshops.lua`.
