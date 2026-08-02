# Shop Window

A shop's 'list' copied into a panel as clickable rows — the MUD's own list still prints as normal: level, the item in the colour the MUD gave it, and the price. Clicking one sends 'buy <num>' — Aardwolf's buy takes the list number, so there is no keyword to guess at — and stops there. It won't wear or wield anything for you. Type `list` as normal — the module needs no alias of its own.

## Install

1. Download `Shop Window.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `77` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `(panel) click a row` | sends 'buy <num>' for that item and stops there |
| `shopwin` | show or hide the panel |
| `shopwin on\|off` | copy 'list' to the panel, or main window only |
| `shopwin up\|down` | scroll the list |
| `shopwin buy <row>` | same as clicking that row |
| `shopwin clear` | empty it |
| `shopwin dock\|embed\|show\|hide` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/shopwin.lua`.
