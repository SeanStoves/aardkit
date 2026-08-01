# aardwolf-mudlet-plugins

 Mudlet modules for the [Aardwolf](https://www.aardwolf.com/) MUD.

Each module lives in its own folder with a README. They share a small core, so
**install [Solao Aardwolf Core](Solao%20Aardwolf%20Core/README.md) first at
priority 1** — without it the others have no `solao.util`, `solao.panel` or
`solao.register` to load against.

Install any of them with **Toolbox → Module Manager → Install** and set the
priority listed in its README. Tick **Sync** to have edits saved back to the file
and shared across your profiles.

## Modules

| Priority | Module | What it does |
|---|---|---|
| 1 | [Solao Aardwolf Core](Solao%20Aardwolf%20Core/README.md) | Shared foundation every other module builds on: the panel manager, output helpers, the command registry and the Aardwolf tag gag. |
| 10 | [Session Log](Session%20Log/README.md) | Session logging to <profile>-YYYYMMDD-HHmm, with timestamps. |
| 20 | [Map Import](Map%20Import/README.md) | Imports an Aardwolf MUSHclient mapper database into Mudlet's own map. |
| 25 | [Vital Shortcuts](Vital%20Shortcuts/README.md) | Keyboard shortcuts for the things you type a hundred times a night. |
| 26 | [ASCII Map](ASCII%20Map/README.md) | The MUD's own ASCII map in a panel of its own. |
| 30 | [Info Window](Info%20Window/README.md) | Captures INFO: lines into their own panel, colours intact, and gags them from the main output. |
| 40 | [Recall Manager](Recall%20Manager/README.md) | A panel of clickable buttons you build yourself. Each fires a list of commands; the grid reflows as you resize it. |
| 45 | [Explorer](Explorer/README.md) | Gaardian-style SVG area maps generated from Mudlet's own map. Read-only. |
| 50 | [Player Tracker](Player%20Tracker/README.md) | Remembers everyone your who sees: clan, level, title, last seen, searchable. |
| 60 | [Loot Tracker](Loot%20Tracker/README.md) | A searchable database of everything you have looted, identified and sold. |
| 65 | [Search and Destroy](Search%20and%20Destroy/README.md) | Quest, campaign and gquest target tracking. |
| 80 | [Goals](Goals/README.md) | Goal tracking off gmcp.char.worth, with announcements when one lands. |
| 85 | [Spellups](Spellups/README.md) | Watches your buffs and their durations, and types the MUD's own spellup when enough have dropped. It has no client-side caster on purpose. |

## Credits

Spellups, Goals and Search and Destroy cover the same ground as plugins by
zzyzzyzzx and AardCrowley. They are reimplementations written from Aardwolf's
published tag protocol, each plugin's own help text and observed output — not
ports. See CREDITS.md.

## Licence

MIT. See LICENSE.
