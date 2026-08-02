# Chat

Aardwolf's channels in eight tabs — All, Private, Group, Tell, Say, Spouse, Clan, Friend — in a window you can drag, resize and dock. The routing is the stock AardwolfMudlet module's, because it is right: tell, say, gtell, ftalk, clantalk and spouse each get their own tab and also copy into Private, everything lands in All, and a channel nobody routes (gossip, market, auction) goes to All alone. Read from GMCP's comm.channel rather than screen triggers, so it can't be broken by a colour setting or a rename. Nothing is gagged — the MUD's own lines stay in the main window exactly as they arrived; these are copies.

## Install

1. Download `Chat.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `27` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `chat` | the tab list and what it is showing |
| `chat <tab>` | switch — 'chat clan', 'chat tell' |
| `chat on\|off` | stop collecting altogether |
| `chat clear [tab]` | empty one, or the one you're looking at |
| `chat mark on\|off` | colour a tab that has something new |
| `chat show\|hide\|dock\|embed` | where the window lives |

Each has its own `help` with the full list.

## Worth knowing

Each tab is its own console, so Mudlet owns the scrollback and the colours per tab and
switching is a show and a hide rather than a repaint.

Nothing is gagged. If you want the main window quieter, that is Aardwolf's own channel
configuration — this module only ever copies.

A tab that isn't the one you're looking at is coloured rather than blinked. It says the same
thing without moving.

## Config

Settings live in `<profile>/aardkit/chat.lua`.
