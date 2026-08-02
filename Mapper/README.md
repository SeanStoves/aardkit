# Mapper

The MUSHclient mapper's commands, on Mudlet's own map — same words, same arguments, so moving across isn't a change of process. Notes live in room user data (saved inside the map, and searchable), custom exits are Mudlet special exits the whole client can speedwalk through, and doors are real: Mudlet draws open, closed and locked differently, which MUSHclient had no notion of. Search and Destroy uses a recorded portal when there's no path on foot — only if one is present, otherwise it fails as before.

## Install

1. Download `Mapper.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `22` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `mapper` | the command list |
| `mapper help exits\|search` | the fuller lists |
| `mapper thisroom` | everything known about where you stand |
| `mapper areas [name]` | areas and room counts |
| `mapper showroom <id>` | centre the map elsewhere |
| `mapper unmapped [here\|<area>]` | exits that lead nowhere yet |
| `mapper find <text>` | search room names and notes |
| `mapper area <text>` | the same, this area only |
| `mapper notes [here\|<area>]` | rooms you have noted |
| `mapper shops\|train\|quest [here\|<area>]` | rooms flagged as such |
| `mapper where <room id>` | directions from here |
| `mapper next [n]` | walk to the next search result |
| `mapper addnote <text>` | note this room |
| `mapper delete note` | remove it |
| `mapper cexits [here\|<area>]` | list custom exits |
| `mapper cexit <command>` | run it and link where you end up (';;' between steps) |
| `mapper fullcexit {<cmd>} <from> <to>` | link without walking it |
| `mapper delete cexits` | this room's custom exits |
| `mapper delete exits from\|to <room>` | exits between here and there |
| `mapper purge cexits [area]` | everywhere, or this area |
| `mapper door <dir> none\|open\|closed\|locked` | mark a door |
| `mapper backup [path]` | write a copy of the map |
| `mapper purgeroom \| purgezone <area>` | delete a room or an area |
| `mapper zoom in\|out` | map zoom |
| `mapper shownotes\|quicklist\|compact\|updown` | display toggles |
| `mapper database` | where the map lives |
| `mapper portals [here\|<area>]` | hand-held portals you have recorded |
| `mapper portals learn` | portal items you own, read from Loot Tracker if it is installed |
| `mapper portal <command>` | record one — stand where it drops you |
| `mapper portalrecall <#>` | flag it as using a recall |
| `mapper portallevel <#> <n>` | level lock, 0 for none |
| `mapper bounceportal [#\|clear]` | which portal to route through for a noportal room |
| `mapper bouncerecall [#\|clear]` | the same for norecall |
| `mapper noportal\|norecall [<room>] [true\|false]` | mark a room |
| `mapper change portal {<old>} {<new>}` | rename the command |
| `mapper delete portal <cmd\|#n>` | remove one |
| `mapper purge portals` | remove them all |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/mapper.lua`.
