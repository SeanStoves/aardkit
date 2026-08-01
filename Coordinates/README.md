# Coordinates

Aardwolf puts an x,y on every room in the big open zones — the Aylor street grid, the continent, the oceans, the air you fly through. This reads that tag, gags it, and keeps the position in a small draggable panel whose title is the reading. Name a target and it counts down the distance and hands you the `run` command to get there.

## Install

1. Download `Coordinates.xml`.
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
| `coord` | where you are, the target, and the Vidblain presets |
| `coord 11,8` | aim at a coordinate |
| `coord <name>` | aim at a Vidblain preset, e.g. `coord omen tor` |
| `coord run` | send the run command for the straight line |
| `coord clear` | drop the target |
| `coord show off|coordareas|always` | when the panel has anything to say |
| `coord panel [show|hide|dock|embed]` | move the panel or put it away |
| `vid ...` | every command above also answers to `vid` |

Each has its own `help` with the full list.

## Worth knowing

The panel is visible from the moment you install it and reads `Location: -` until
you walk somewhere with a grid. `coord show off` puts it away for good; `coord panel
hide` just hides it until next time.

The three display modes decide what the title says, not whether the tag is gagged —
the `{coords}` line is swallowed either way. `coordareas` (the default) shows the plain
position anywhere there's a grid and only counts down to a target inside Vidblain.
`always` counts down wherever you are. `off` hides the panel.

The named targets are Vidblain's exits and nothing else — it drops you somewhere
random and every way out is a fixed coordinate, which is the case worth presetting.
Everywhere else, give it an `x,y`.

The axes were measured, not assumed: from 24,18 a `run 2s5e` lands on 29,20, so x
grows east and **y grows south**. The learning code is still there, so if that is ever
wrong one clean move corrects it.

`coord run` sends a straight-line `run` toward the target. Vidblain is a maze, so that
will often be blocked — the MUD gives up after three failed moves and you run it
again from wherever you ended up. It's a nudge, not a pathfinder.

## Config

Settings live in `<profile>/aardkit/coords.lua`.
