# Consider

Rewrites what `con all` tells you about the room: verdict first and colour-coded, then the level difference, the name and any flags. No panel — it tidies the lines where they stand. If Search and Destroy is installed it also feeds it every mob it names, which is a far better source than the room description.

## Install

1. Download `Consider.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `68` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `xcon` | whether the lines are being rewritten |
| `xcon on \| off` | rewrite them, or leave the MUD's own |

Each has its own `help` with the full list.

## Better with

Nothing here is required. This module works on its own; these only remove a
manual step if you happen to have them, and it says so at the moment the
manual step comes up rather than nagging at you on load.

| Module | With it | Without it |
|---|---|---|
| [Search and Destroy](../Search%20and%20Destroy/README.md) | every mob it names is fed to the mob database, which is a far better source than room descriptions | it just tidies the consider lines where they stand |


## Worth knowing

It never sends `consider` for you — type `con all` yourself and this tidies the
answer. The ranking and colours are ours; the verdict wording is the MUD's.

## Config

Settings live in `<profile>/aardkit/consider.lua`.
