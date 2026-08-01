# Search and Destroy

Quest, campaign and gquest target tracking.

## Install

1. Download `Search and Destroy.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `65` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [aardcore](../aardcore/README.md) installed first at priority 1 — it holds
the shared `aard.util` / `aard.panel` / `aard.register` that every module here
builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `snd` | |
| `mobwhere` | |

Every one of these has its own `help`; that's the authoritative list.

## Config

Settings live in `<profile>/aard/snd.lua`.
