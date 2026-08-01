# Goals

Goal tracking off gmcp.char.worth, with announcements when one lands.

## Install

1. Download `Goals.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `80` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `goal` | |

Every one of these has its own `help`; that's the authoritative list.

## Config

Settings live in `<profile>/solao/goals.lua`.
