# Map Import

Imports an Aardwolf MUSHclient mapper database into Mudlet's own map.

## Install

1. Download `Map Import.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `20` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `aardmap` | |

Every one of these has its own `help`; that's the authoritative list.

## Config

Settings live in `<profile>/solao/mapimport.lua`.
