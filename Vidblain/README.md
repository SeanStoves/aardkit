# Vidblain

Puts your Vidblain coordinates on the room name line, and tells you how far it is to the exit you want. Vidblain drops you somewhere random and every way out is a fixed coordinate.

## Install

1. Download `Vidblain.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `48` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `vid` | current coordinates, target, and the known exits |
| `vid <name>` | aim at a known exit, e.g. `vid omen tor` |
| `vid 11,8` | aim at a coordinate |
| `vid clear` | drop the target |
| `vid show off|coordareas|always` | where coordinates get shown |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/solao/vidblain.lua`.
