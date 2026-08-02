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
| `chat opacity <0-255>` | how solid this window is; 'default' follows the shared setting |
| `chat` | the tab list and what it is showing |
| `chat <tab>` | switch — 'chat clan', 'chat tell' |
| `chat on\|off` | stop collecting altogether |
| `chat clear [tab]` | empty one, or the one you're looking at |
| `chat mark on\|off` | colour a tab that has something new |
| `chat show\|hide\|dock\|embed` | where the window lives |
| `chat standalone on\|off` | stop the stock module's own chat tabs |

Each has its own `help` with the full list.

## Worth knowing

Channels come from GMCP's `comm.channel`, which carries **51 of them** — every
channel Aardwolf has. Six are routed to their own tab and the rest land in All.

Three things the MUD prints are NOT channels and never arrive on that message, so they are
captured off the screen instead — the same three the stock module captures, to the same
tabs: `Remort Auction:` lines to Private, All and Group; a won Global Quest to All; and remote
socials to Private, All and Group. The social capture matches `^\*.*$`, which catches a great
deal that isn't one, so it then checks the line is Aardwolf teal — that test is theirs and
it earns its place. Captured with `selectCurrentLine` and `appendBuffer`, so the MUD's own
colours come across intact and nothing is reconstructed.

**Installing this takes the channels over.** If the stock AardwolfMudlet module is
present, its `onChannel` script is switched off and its eight tabs come out of the frame —
two sets of chat tabs is worse than either. It is a switch, not a one-way door:
`chat standalone off` hands them straight back, and nothing of theirs is deleted, only
disabled. If that module isn't installed there is nothing to stand down.

Each tab is its own console, so Mudlet owns the scrollback and the colours per tab and
switching is a show and a hide rather than a repaint.

Nothing is gagged. If you want the main window quieter, that is Aardwolf's own channel
configuration — this module only ever copies.

A tab that isn't the one you're looking at is coloured rather than blinked. It says the same
thing without moving.

## Config

Settings live in `<profile>/aardkit/chat.lua`.
