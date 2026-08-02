# Search Window

A second, readable copy of 'search all' / 'eqsearch all' in a panel of its own, paged and fresh every run — the report still scrolls past in the main window, this just doesn't scroll away. Aardwolf has no tag for this the way it does for helpfiles, so it reads the report's own opening line and stops at the prompt — the Note block at the end is advice the MUD can reword, the prompt is structural.

## Install

1. Download `Search Window.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `76` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `searchwin opacity <0-255>` | how solid this window is; 'default' follows the shared setting |
| `searchwin` | this list |
| `searchwin toggle` | show or hide the panel |
| `searchwin gag` | hide it from the main window, or show it in both |
| `searchwin on\|off` | copy it to the panel, or main window only |
| `searchwin next\|prev` | page through it, same as the buttons |
| `searchwin clear` | empty it |
| `searchwin dock\|embed\|show\|hide` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/searchwin.lua`.
