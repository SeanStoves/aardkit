# Shop Window

A shop's 'list' copied into a panel as clickable rows — the MUD's own list still prints as normal: level, the item in the colour the MUD gave it, and the price. Each row carries quantity buttons — 1/5/10/25/50/100 by default, set with `shopwin qty` — that send 'buy <n> <num>' — Aardwolf's buy takes a count and the list number, so there is no keyword to guess at — and stop there. Clicking the name appraises it instead — free, and the stat box it prints is caught by the Loot Tracker — so no purchase happens without naming a quantity first, and the click you make by accident is the one that costs nothing. It won't wear or wield anything for you. Type `list` as normal — the module needs no alias of its own.

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
| `(panel) click the name` | appraises it — costs nothing, and fills the stat table |
| `(panel) 1 5 10 25 50 100` | the buttons beside a row — sends 'buy <n> <num>' and stops there |
| `shopwin` | this list |
| `shopwin toggle` | show or hide the panel |
| `shopwin gag` | hide it from the main window, or show it in both |
| `shopwin on\|off` | copy 'list' to the panel, or main window only |
| `shopwin up\|down` | page through the list, same as the buttons |
| `shopwin buy <row> [n]` | same as clicking that row's number button |
| `shopwin appraise <row>` | same as clicking the name |
| `shopwin qty <list>` | which buy buttons a row carries, e.g. 1,5,10 (default 1,5,10,25,50,100; anything negative, zero or over 1000 is rejected and named) |
| `shopwin clear` | empty it |
| `shopwin dock\|embed\|show\|hide` | panel placement |

Each has its own `help` with the full list.

## Better with

Nothing here is required. This module works on its own; these only remove a
manual step if you happen to have them, and it says so at the moment the
manual step comes up rather than nagging at you on load.

| Module | With it | Without it |
|---|---|---|
| [Loot Tracker](../Loot%20Tracker/README.md) | clicking an item name appraises it and the stat box is caught and stored | the appraise still prints, it just is not recorded |


## Config

Settings live in `<profile>/aardkit/shopwin.lua`.
