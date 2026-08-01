# Aardkit

 Mudlet modules for the [Aardwolf](https://www.aardwolf.com/) MUD.

Each module lives in its own folder with a README. They share a small core, so
**install [Aardkit Core](Aardkit%20Core/README.md) first at
priority 1** — without it the others have no `aardkit.util`, `aardkit.panel` or
`aardkit.register` to load against.

Install any of them with **Toolbox → Module Manager → Install** and set the
priority listed in its README. Tick **Sync** to have edits saved back to the file
and shared across your profiles.

## Modules

| Priority | Module | What it does |
|---|---|---|
| 1 | [Aardkit Core](Aardkit%20Core/README.md) | Shared foundation every other module builds on: the panel manager, saved state under `<profile>/aardkit/`, coloured output and help formatting, the command registry, and the Aardwolf tag gag. |
| 10 | [Session Log](Session%20Log/README.md) | Session logging that starts on connect and names files `log/<profile>-YYYYMMDD-HHmm`, renaming stray logs into the same scheme. |
| 30 | [Info Window](Info%20Window/README.md) | Captures INFO: lines into their own panel, colours intact, and gags them from the main output. |
| 40 | [Recall Manager](Recall%20Manager/README.md) | Clickable command buttons you define yourself — each fires a `|`-separated list of commands with `$var` substitution, tracks a use count, and can watch for an arrival line to show where you are. The grid reflows and scrolls as you resize the panel. |
| 45 | [Explorer](Explorer/README.md) | Gaardian-style SVG area maps generated from Mudlet's own map data, one grid per z level, written to a folder you choose. It also dumps rooms and links as JSON. It reads the map and never moves you or changes it. |
| 48 | [Vidblain](Vidblain/README.md) | Puts your Vidblain coordinates on the room name line, and tells you how far it is to the exit you want. Vidblain drops you somewhere random and every way out is a fixed coordinate. |
| 50 | [Player Tracker](Player%20Tracker/README.md) | Keeps a record of everyone your `who` sweeps see — clan, level/race/class, title and last-seen — searchable by name, title or clan. |
| 60 | [Loot Tracker](Loot%20Tracker/README.md) | A searchable record of where items come from — which mob dropped it, which room object it was picked off, and which shops stock it and for how much — plus stat blocks read off any id or appraise box that scrolls past, with optional sync to a shared pool. |
| 65 | [Search and Destroy](Search%20and%20Destroy/README.md) | A searchable mob and area database carried over from the MUSHclient plugin, a three-tab panel that reads your quest, campaign and gquest targets from the MUD and walks you to one when you click it, and `ah <mob>` to follow the MUD's own hunt skill into areas your map has never seen. |
| 68 | [Consider](Consider/README.md) | Rewrites what `con all` tells you about the room: verdict first and colour-coded, then the level difference, the name and any flags. No panel — it tidies the lines where they stand. |
| 80 | [Goals](Goals/README.md) | Savings targets against the six currencies in `gmcp.char.worth` — qp, tp, gold, bank, trains, pracs — announced once the moment one is met, to your screen or a MUD channel. |
| 85 | [Spellups](Spellups/README.md) | Tracks what's on you, what's blocked by a recovery and why the last cast failed, from Aardwolf's spell tag stream. The autocaster only ever types the MUD's own `spellup` and lets the MUD pick the spells. Separate opt-in extras, all off by default, do send individual casts — totem, eye of vigilance and a pre-cast list for wraith form. |

## Credits

Spellups, Goals and Search and Destroy cover the same ground as plugins by
zzyzzyzzx and AardCrowley. They are reimplementations written from Aardwolf's
published tag protocol, each plugin's own help text and observed output — not
ports. See CREDITS.md.

## Licence

MIT. See LICENSE.
