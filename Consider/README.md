# Consider

Rewrites what `con all` tells you about the room: verdict first and colour-coded, then the level difference, the name and any flags. No panel — it tidies the lines where they stand.

## Install

1. Download `Consider.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `68` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Solao Aardwolf Core](../Solao%20Aardwolf%20Core/README.md) installed first
at priority 1 — it holds the shared `solao.util` / `solao.panel` / `solao.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `xcon` | whether the lines are being rewritten |
| `xcon on | off` | rewrite them, or leave the MUD's own |

Each has its own `help` with the full list.

## Config

Settings live in `<profile>/solao/consider.lua`.
