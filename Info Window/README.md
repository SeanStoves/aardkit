# Info Window

Captures INFO: lines into their own panel, colours intact, and gags them from the main output.

## Install

1. Download `Info Window.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `30` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `infowin` | show/hide the panel |
| `infowin buffer <n>` | scrollback lines, 10-5000 |
| `infowin gag` | toggle gagging INFO from the main window |
| `infowin clear` | empty the panel |
| `infowin show|hide|dock|embed` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/infowindow.lua`.
