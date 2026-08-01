# Search and Destroy

A searchable mob and area database carried over from the MUSHclient plugin, a three-tab panel that reads your quest, campaign and gquest targets from the MUD and walks you to one when you click it, and `ah <mob>` to follow the MUD's own hunt skill into areas your map has never seen.

## Install

1. Download `Search and Destroy.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `65` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `snd` | toggle the target panel |
| `snd cp | quest | gq` | ask the MUD for that target list |
| `snd go <n>` | speedwalk to target n |
| `snd next` | walk to the first target listed |
| `ah <mob>` | auto-hunt: follow the MUD's hunt skill to it |
| `aha` | cancel the hunt |
| `snd status` | row counts for mobs/areas/keywords, scan state |
| `snd mob <kw>` | rooms a mob was seen in, clickable [go] |
| `mobwhere <kw>` | same lookup, shorter alias |
| `snd area [text]` | area list with level ranges and start rooms |
| `snd keywords` | read 'area keyword' so runto works for unmapped areas |
| `snd scan on|off` | record mobs from room descriptions while moving |
| `snd dock|embed|hide|show` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/snd.lua`.
