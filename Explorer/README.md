# Explorer

Gaardian-style SVG area maps generated from Mudlet's own map data, one grid per z level, written to a folder you choose. It also dumps rooms and links as JSON. It reads the map and never moves you or changes it.

## Install

1. Download `Explorer.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `45` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `explore` | repaint and toggle the panel |
| `explore svg [area]` | write an SVG map, default current area |
| `explore json [area]` | write rooms and links as JSON |
| `explore all` | write an SVG for every area |
| `explore list [filter]` | list areas with room counts |
| `explore dir [path]` | show or set the output folder |
| `explore show|hide|dock|embed` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/solao/explorer.lua`.
