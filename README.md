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
| 1 | [Aardkit Core](Aardkit%20Core/README.md) | Shared foundation every other module builds on: a GMCP watcher that hands out char.* at a rate you can read rather than the rate the MUD sends it, the panel manager, saved state under `<profile>/aardkit/`, coloured output and help formatting, the command registry, and the Aardwolf tag gag. Also switches off the stock AardwolfMudlet aliases that would otherwise fight ours, with `aardkit stock` to flip any one of them back on. |
| 10 | [Session Log](Session%20Log/README.md) | Session logging that starts on connect and names files `log/<profile>-YYYYMMDD-HHmm`, renaming stray logs into the same scheme. |
| 30 | [Info Window](Info%20Window/README.md) | Captures INFO: lines into their own panel, colours intact, and gags them from the main output — along with the blank line Aardwolf pads each one with, which is otherwise a fifth of everything on your screen. |
| 35 | [Stat Monitor](Stat%20Monitor/README.md) | Your stats against their training caps, hitroll and damroll, level, alignment, hp/mana/moves and what you are worth, grouped and reflowing from one column to four as you drag the panel. The extras Aardwolf also sends — name, race, class, clan, tier, bank — are off until you ask for them. Read-only: it draws what GMCP has already sent and never asks the MUD for anything. |
| 40 | [Recall Manager](Recall%20Manager/README.md) | Clickable command buttons you define yourself — each fires a `\|`-separated list of commands with `$var` substitution, tracks a use count, and can watch for an arrival line to show where you are. The grid reflows and scrolls as you resize the panel. |
| 45 | [Explorer](Explorer/README.md) | Gaardian-style SVG area maps generated from Mudlet's own map data, one grid per z level, written to a folder you choose. It also dumps rooms and links as JSON. It reads the map and never moves you or changes it. |
| 48 | [Coordinates](Coordinates/README.md) | Aardwolf puts an x,y on every room in the big open zones — the Aylor street grid, the continent, the oceans, the air you fly through. This reads that tag, gags it, and keeps the position in a small draggable panel whose title is the reading. Name a target and it counts down the distance and hands you the `run` command to get there. |
| 50 | [Player Tracker](Player%20Tracker/README.md) | Keeps a record of everyone your `who` sweeps see — clan, level/race/class, title and last-seen — searchable by name, title or clan. |
| 60 | [Loot Tracker](Loot%20Tracker/README.md) | A searchable record of where items come from — which mob dropped it, which room object it was picked off, and which shops stock it and for how much — plus stat blocks read off any id or appraise box that scrolls past, with optional sync to a shared pool. |
| 65 | [Search and Destroy](Search%20and%20Destroy/README.md) | A searchable mob and area database carried over from the MUSHclient plugin, a three-tab panel that reads your quest, campaign and gquest targets from the MUD and walks you to one when you click it, and `ah <mob>` to follow the MUD's own hunt skill into areas your map has never seen. |
| 68 | [Consider](Consider/README.md) | Rewrites what `con all` tells you about the room: verdict first and colour-coded, then the level difference, the name and any flags. No panel — it tidies the lines where they stand. If Search and Destroy is installed it also feeds it every mob it names, which is a far better source than the room description. |
| 75 | [Help Window](Help%20Window/README.md) | Help files in a panel of their own that starts empty on every read, instead of scrolling past in the main window. Aardwolf marks its own help output once you ask it to over telnet channel 102, so there is nothing to scrape and nothing to re-tune when your screen width changes. It pages rather than scrolls: a scrolled Mudlet console splits into two panes with a divider, which is right for the MUD window and wrong for a document, so the file goes into an off-screen buffer and one screenful is shown at a time. Colours survive the trip. Read help the way you always have — `help <topic>` is the MUD's own command and needs no alias from us. |
| 76 | [Search Window](Search%20Window/README.md) | A second, readable copy of 'search all' / 'eqsearch all' in a panel of its own, paged and fresh every run — the report still scrolls past in the main window, this just doesn't scroll away. Aardwolf has no tag for this the way it does for helpfiles, so it reads the report's own opening line and stops at the prompt — the Note block at the end is advice the MUD can reword, the prompt is structural. |
| 77 | [Shop Window](Shop%20Window/README.md) | A shop's 'list' copied into a panel as clickable rows — the MUD's own list still prints as normal: level, the item in the colour the MUD gave it, and the price. Clicking one sends 'buy <num>' — Aardwolf's buy takes the list number, so there is no keyword to guess at — and stops there. It won't wear or wield anything for you. Type `list` as normal — the module needs no alias of its own. |
| 80 | [Goals](Goals/README.md) | Savings targets against the six currencies in `gmcp.char.worth` — qp, tp, gold, bank, trains, pracs — announced once the moment one is met, to your screen or a MUD channel. |
| 85 | [Spellups](Spellups/README.md) | Tracks what's on you, what's blocked by a recovery and why the last cast failed, from Aardwolf's spell tag stream. The autocaster only ever types the MUD's own `spellup` and lets the MUD pick the spells. Separate opt-in extras, all off by default, do send individual casts — totem, eye of vigilance and a pre-cast list for wraith form. |

## Colours

Mudlet ships the VGA palette, in which the *normal* eight colours are the dark
half — plain blue is `#000080`, navy on a black background. Aardwolf writes a
great deal in plain `@b`, so a lot of the MUD arrives close to unreadable, and
several other clients use a brighter set by default. It's not a terminal thing:
Mudlet draws its own text and carries its own palette.

Nothing here can change it for you. The palette lives in the profile's own
settings and Mudlet has no Lua function to write it — `getAnsiColor` reads,
nothing sets, and `setConfig` has no ANSI keys. So `aardkit colours` shows what
you have beside a readable set and leaves the typing to you.

**Settings → Preferences → Display**, the colour swatches:

| | normal | | bright |
|---|---|---|---|
| black | `#3C3C3C` | light black | `#BCBCBC` |
| red | `#F80000` | light red | `#FF7878` |
| green | `#00F800` | light green | `#78FF78` |
| yellow | `#F8F800` | light yellow | `#FFFF78` |
| blue | `#0000F8` | light blue | `#7878FF` |
| magenta | `#F800F8` | light magenta | `#FF78FF` |
| cyan | `#00F8F8` | light cyan | `#78FFFF` |
| white | `#FCFCFC` | light white | `#FFFFFF` |

Black is `#3C3C3C` rather than `#000000` on purpose — that's what makes `@D`
grey legible on a black background instead of invisible.


## Credits

Spellups, Goals and Search and Destroy cover the same ground as plugins by
zzyzzyzzx and AardCrowley. They are reimplementations written from Aardwolf's
published tag protocol, each plugin's own help text and observed output — not
ports. See CREDITS.md.

## Licence

MIT. See LICENSE.
