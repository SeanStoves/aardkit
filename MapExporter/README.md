# MapExporter

Gaardian-style SVG area maps generated from Mudlet's own map data, one grid per z level, written to a folder you choose. It also dumps rooms and links as JSON. Every write prints an [open] link that hands the file to whatever your machine uses for SVG. It reads the map and never moves you or changes it.

## Install

1. Download `MapExporter.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `45` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `mapexport` | this list |
| `mapexport status` | areas in the map, where you are, where files go |
| `mapexport toggle` | repaint, and show or hide the panel |
| `mapexport svg [area]` | write an SVG map, default current area |
| `mapexport json [area]` | write rooms and links as JSON |
| `mapexport all` | write an SVG for every area |
| `mapexport list [filter]` | list areas with room counts |
| `mapexport dir [path]` | show or set the output folder |
| `mapexport show\|hide\|dock\|embed` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/mapexporter.lua`.
