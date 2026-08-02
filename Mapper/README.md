# Mapper

The MUSHclient mapper's commands, on Mudlet's own map — same words, same arguments, so moving across isn't a change of process. Notes live in room user data (saved inside the map, and searchable), custom exits are Mudlet special exits the whole client can speedwalk through, and doors are real: Mudlet draws open, closed and locked differently, which MUSHclient had no notion of. It maps as you walk, too: rooms, coordinates, exits, doors and terrain colours straight from GMCP, with the rule that an existing room is never moved, renamed or shifted between areas — only new rooms get placed, so an imported map can't be spoiled by a bad guess. 'mapper style aard' draws it the way the MUSHclient mapper does: solid terrain-coloured tiles with no exit lines on the continent, ordinary rooms-and-corridors everywhere else, and a symbol in the shops and healers. It also carries the map itself in a panel you can actually move — the stock AardwolfMudlet module nails its mapper into a fixed frame, and if that module is installed this takes the map out of it. Search and Destroy uses a recorded portal when there's no path on foot — only if one is present, otherwise it fails as before.

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
| `mapper mapping [on\|off]` | the mapping engine — what it has created, and whether it is writing |
| `mapper mapping forget` | drop the zone-to-area table — after an 'aardmap import' renumbers everything |
| `mapper style autogrid on\|off` | draw continent areas as tiles automatically (on) |
| `mapper style unexplored on\|off` | draw rooms GMCP names and you've never entered, with a '?' (on) |
| `mapper autocexit on\|off` | record a non-direction move as a custom exit (off: flee and recall move you too) |
| `mapper style` | how the map draws |
| `mapper style aard` | the MUSHclient look — solid terrain tiles, no exit lines, symbols |
| `mapper style restore` | put your own Mudlet map settings back |
| `mapper style grid on\|off` | this area as solid tiles, or as rooms and exit lines |
| `mapper style symbols [off]` | mark shops, healers, banks and the rest in this area |
| `mapper style symbols all` | every room in the map, chunked so the client stays alive — run once |
| `mapper style clear` | take the symbols off this area |
| `mapper style ids on\|off` | room numbers painted on the map |
| `mapper style room\|exit <n>` | the two sizes the presets leave alone |
| `mapper backup [path]` | write a copy of the map |
| `mapper purgeroom \| purgezone <area>` | delete a room or an area |
| `mapper map` | the Mapper panel — drag it, resize it, dock it, it stays put |
| `mapper unframe` | hide the stock module's embedded map by hand, if it comes back |
| `mapper reframe` | give their map widget straight back to them |
| `mapper standalone on\|off` | stop the stock module writing to the map — costs you its speedwalk, coordrun and 'where' |
| `mapper show\|hide\|dock\|embed` | where the Mapper panel lives |
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

## Better with

Nothing here is required. This module works on its own; these only remove a
manual step if you happen to have them, and it says so at the moment the
manual step comes up rather than nagging at you on load.

| Module | With it | Without it |
|---|---|---|
| [Loot Tracker](../Loot%20Tracker/README.md) | 'mapper portals learn' lists the portal items you've identified, reading 'Type: Portal' and 'Leads to:' off the id box | record portals by hand with 'mapper portal <command>' while standing where one drops you |


## Worth knowing

**Installing this takes the map over.** If the stock AardwolfMudlet module is
present, three of its pieces are switched off on load, because two things writing one map is
how rooms end up in the wrong place:

| Theirs | What it did | What does it here |
|---|---|---|
| `onRoom` (script) | wrote rooms and exits on every move | this module, via their own `aard.map.enable` |
| `where` (trigger) | the 'Players near you' capture | Player Tracker, and `mapper where <room>` |
| `map quest cp gq` (triggers) | campaign and quest target capture | Search and Destroy's own capture and panel |

Their mapper is stood down through **their own switch**, not by disabling their script. Their config sets `aard.map.enable`, `guiLoad` does `if (aard.map.enable) then aard:init_map() end`, and `onRoom`'s second line is `if not (aard.map.init) then return end`. That flag is what their author put there for this, it survives them renaming a script, and it is more precise than a name lookup: the guard sits below the line that keeps `aard.map.current_room` fresh, so their other pieces that read it keep working and only the map writing stops.

Their `aard.gui.enable` is declared and never read — their own comment marks it "currently unused" — so there is no built-in switch for the rest of their GUI. That is what `aardkit stock all off` is for.

**It is a switch, not a one-way door.** `mapper standalone off` hands the map straight back to
theirs; `mapper standalone on` takes it again; `mapper standalone` on its own lists exactly what
moves in each direction and which way round you are now. Nothing of theirs is deleted — only
disabled — and if that module isn't installed there is nothing to stand down and this changes
nothing. Their `tools` script is deliberately left alone: their own init calls it.

If you want the whole of their module gone rather than just its mapping, `aardkit stock all off` disables every trigger, alias, script and key of theirs in one go — they all live under a single group per package, so nothing is deleted and `aardkit stock all on` puts it back. Read `aardkit stock all` first: it lists what goes with it, and the chat tabs, gauges, group panel and numpad bindings have not been rebuilt here yet.

Swapping back costs you what theirs provides and this doesn't: their speedwalk, their coordrun.
Swapping to ours costs you nothing you haven't been given a replacement for, which is what the
table above is for.

**Your existing map is safe.** A room already in the map is never moved, never renamed, and never
shifted between areas — only new rooms get placed, and an old one has blanks filled in and
nothing else. So the worst a bad guess can do is put one new room somewhere daft, and
`mapper purgeroom` undoes that. Run `mapper mapping` any time to see what it has created.

**There is only one map view per Mudlet profile.** Mudlet's own Geyser.Mapper says so — mappers are singleton per profile — so two `Geyser.Mapper` objects aren't two maps, they're two claims on the same one, and the last claim wins. The stock module builds its map on a timer after this module has loaded, so without help theirs wins and the panel here comes up empty.

This takes the view back once theirs is down, and again on `mapper map`, `mapper unframe`, `mapper dock` and `mapper embed`. If the panel is ever blank, `mapper map` claims it again and says so if it can't. Going the other way, `mapper standalone off` gives up the view and asks you to reload — their widget isn't ours to rebuild.

The panel is called **Mapper**. The ASCII Map panel is a different module and a different thing: that one is the MUD's own live drawing of where you are, this one is the stored map.

Rooms Aardwolf names in its exit list but you've never walked into are drawn one step away with
a `?` in them, so an area you've half-explored looks half-explored. They fill in the moment you
step in. `mapper style unexplored off` if you'd rather not.

**The map is drawn the MUSHclient way by default**, not the Mudlet way — that plugin's
appearance is most of what people miss about it. Square rooms with borders on a #111111 field,
#e0ffff exit lines, no room ids, and its fills for the rooms you go looking for: shops
#ffad2f, banks #ffd700, healers and trainers #9acd32, guilds magenta, questors deepskyblue,
safe rooms lightblue, and #9b0000 for a room you know is there and have never stood in. Those
numbers are read off that plugin's own settings; none of its code is here.

Continent areas draw as solid terrain-coloured tiles with no exit lines — their mapper
tiles areas with terrain textures, Mudlet has no textures, and a coloured room is the nearest
true thing. GMCP flags continent rooms, so it's per area and an inn keeps its corridors.

Everything `mapper style` changes is a Mudlet preference of yours. The old values are written
down before anything is touched and `mapper style restore` puts them back exactly —
including the terrain colour sitting under a flag fill, which is parked in room user data
rather than thrown away. `mapper style autogrid off` stops the continent tiling,
`mapper style grid on|off` does one area by hand.

Room size and exit size are the two it won't touch: their scale isn't discoverable from
Mudlet's binary, and a wrong guess resizes every map you own. `mapper style` prints both and
`mapper style room|exit <n>` sets them — the MUSHclient proportion is a room 12 wide with
8 between, if you want to match it exactly.

## Config

Settings live in `<profile>/aardkit/mapper.lua`.
