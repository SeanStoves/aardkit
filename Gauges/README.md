# Gauges

The hp, mana, moves, tnl, align and enemy bars, in the stock AardwolfMudlet module's own three-by-two arrangement and its own colours — read out of its config script rather than eyeballed. Straight off GMCP: char.vitals for the three that move constantly, char.maxstats for what they're out of, char.status for the rest. Theirs are nailed into the bottom of its frame; this is a panel like every other one here, so drag it, resize it, dock it, and it stays where you left it. Any of the six can be switched off and the others widen to fill the space.

## Install

1. Download `Gauges.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `28` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `gauges` | which bars are on, and whether they are updating |
| `gauges on\|off` | stop updating them |
| `gauges <bar> on\|off` | hide one — enemy, moves, tnl, health, mana, align |
| `gauges show\|hide\|dock\|embed` | where the window lives |
| `gauges opacity <0-255>` | how solid this window is; 'default' follows the shared setting |

Each has its own `help` with the full list.

## Worth knowing

The bracketed potion count the stock module's bars show — `(0)` — is not carried
across. It comes from three trigger-driven counters this suite doesn't have, and a bracket that
always reads zero is worse than no bracket.

Alignment is a range rather than a quantity, so the bar shows how far from neutral you are and
the colour says which way: their #d98839 good, #888 neutral, #8c2929 evil.

TNL fills as you approach the level rather than draining, which is what theirs does too.

## Config

Settings live in `<profile>/aardkit/gauges.lua`.
