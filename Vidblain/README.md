# Vidblain

Vidblain drops you somewhere random and every way out is a fixed coordinate, so this reads the `{coords}` tag the MUD sends on every room, gags it, and puts the position in a small draggable panel of its own — the reading is the panel title. Name an exit and it counts down the distance to it and hands you the `run` command to get there.

## Install

1. Download `Vidblain.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `48` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `vid` | current coordinates, target, and the known exits |
| `vid <name>` | aim at a known exit, e.g. `vid omen tor` |
| `vid 11,8` | aim at a coordinate |
| `vid run` | send the run command for the straight line |
| `vid clear` | drop the target |
| `vid show off|coordareas|always` | when the panel has anything to say |
| `vid panel [show|hide|dock|embed]` | move the panel or put it away |

Each has its own `help` with the full list.

## Worth knowing

The panel is visible from the moment you install it and reads `Location: -` until
you walk into somewhere with coordinates. `vid show off` puts it away for good;
`vid panel hide` just hides it until next time.

The three display modes decide what the title says, not whether the tag is gagged —
the `{coords}` line is swallowed either way. `coordareas` (the default) shows the
plain position in any coordinate area and only counts down to a target inside
Vidblain. `always` counts down wherever you are. `off` hides the panel.

The axes were measured, not assumed: from 24,18 a `run 2s5e` lands on 29,20, so x
grows east and **y grows south**. The learning code is still there, so if that is ever
wrong one clean move corrects it.

`vid run` sends a straight-line `run` toward the target. Vidblain is a maze, so that
will often be blocked — the MUD gives up after three failed moves and you run it
again from wherever you ended up. It's a nudge, not a pathfinder.

## Config

Settings live in `<profile>/aardkit/vidblain.lua`.
