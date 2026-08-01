# Stat Monitor

Everything Aardwolf reports about your character — vitals against their maxima, trained stats against their caps, hitroll/damroll, alignment, and what you are worth — in a panel that reflows from a one-column strip to a four-column bar as you drag it. Read-only: it draws what GMCP has already sent and never asks the MUD for anything.

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
| `stats status` | which groups are on, and how many fields the MUD is sending |
| `stats on\|off <group>` | vitals, char, stats, combat or worth |
| `stats dock\|embed\|show\|hide` | panel placement |

Each has its own `help` with the full list.

## Worth knowing

Fields are drawn only when the MUD actually sends them, so the panel can't show a
label with nothing beside it - and if Aardwolf adds a field it appears with no change
here. Stats show against their training cap (`Str 180/200`); vitals are coloured by
how much is left, but a stat's cap is a ceiling rather than a warning so those stay
plain.

Columns are capped at four. Past that, extra width only ever made more narrow columns
and the labels stayed abbreviated - capped, the columns widen instead and you get the
whole word.

## Config

Settings live in `<profile>/aardkit/statmon.lua`.
