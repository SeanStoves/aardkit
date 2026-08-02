# Help Window

Help files in a panel of their own that starts empty on every read, instead of scrolling past in the main window. Aardwolf marks its own help output once you ask it to over telnet channel 102, so there is nothing to scrape and nothing to re-tune when your screen width changes. Colours are copied across intact. Read help the way you always have — `help <topic>` is the MUD's own command and needs no alias from us.

## Install

1. Download `Help Window.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `75` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `helpwin` | show or hide the panel |
| `helpwin on\|off` | capture help, or leave it in the main window |
| `helpwin keep` | append rather than starting fresh each read |
| `helpwin clear` | empty it |
| `helpwin retry` | ask the MUD to tag help output again |
| `helpwin dock\|embed\|show\|hide` | panel placement |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/helpwin.lua`.
