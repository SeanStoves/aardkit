# Aardkit Core

Shared foundation every other module builds on: the panel manager, saved state under `<profile>/aardkit/`, coloured output and help formatting, the command registry, and the Aardwolf tag gag.

## Install

1. Download `Aardkit Core.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `1` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).


## Commands

| Command | Does |
|---|---|
| `aardkit` | lists core commands and every registered module |
| `aardkit plugins` | names of loaded modules |
| `aardkit probe` | reports which Mudlet Lua functions exist here |
| `panel` | lists panels with mode and visibility |
| `panel <name>` | toggles that panel |
| `panel <name> show\|hide` | shows or hides it |
| `panel <name> dock\|embed` | dockable window vs in-window container |
| `panel <name> clear` | empties its buffer |
| `panel raise` | raises panels above the stock module's GUI |
| `panel save\|load\|reset` | write, reload or clear the saved layout |
| `aardtags` | shows gag state and tag classifications |
| `aardtags on\|off` | turns the gag on or off |
| `aardtags line\|block\|marker <tag>` | classify one tag yourself |
| `aardtags forget <tag>` | drop a custom classification |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/aardkit/aardkitcore.lua`.
