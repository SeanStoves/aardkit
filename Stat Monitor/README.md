# Stat Monitor

Your stats against their training caps, hitroll and damroll, level, alignment, hp/mana/moves and what you are worth, grouped and reflowing from one column to four as you drag the panel. The extras Aardwolf also sends — name, race, class, clan, tier, bank — are off until you ask for them. Read-only: it draws what GMCP has already sent and never asks the MUD for anything.

## Install

1. Download `Stat Monitor.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `35` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `stats` | toggle the panel |
| `stats fields` | every field, what's on, and what the MUD is sending |
| `stats on\|off <field>` | add one of the extras, or drop one you never read |
| `stats reset` | back to the default set |
| `stats dock\|embed\|show\|hide` | panel placement |

Each has its own `help` with the full list.

## Worth knowing

Fields are drawn only when they're switched on AND the MUD is actually sending them,
so the panel can't show a label with nothing beside it. `stats fields` lists every one
with both facts.

Stats read against their training cap. hp/mana/moves are coloured by how much is left;
a stat's cap is a ceiling rather than a warning, so those stay plain.

Geyser doesn't clip a label to its container, so anything laid out below the frame
renders over whatever is behind the panel rather than disappearing. Rather than let
that happen, a group that won't fit isn't drawn and the panel says how many fields
are hidden.

## Config

Settings live in `<profile>/aardkit/statmon.lua`.
