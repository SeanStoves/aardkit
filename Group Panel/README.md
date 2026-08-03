# Group Panel

The party, one row per member, straight off gmcp.group: a health bar with level, name, quests and tnl written across it, mana and moves under that, and alignment as a coloured strip.

The stock module's layout, in a window you can drag and resize — theirs is nailed under the minimap with every member's container parented to the one above it. Two things of theirs are fixed here: their alignment bar is built and hidden on the same pass so it has never once drawn, and their member loop returns from the whole function when maxstats hasn't arrived yet, which stops drawing everyone below you for the first seconds after connect.

'group' stays the MUD's command. This one answers to 'grouppanel'.

## Install

1. Download `Group Panel.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `31` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `grouppanel` | the panel, and what it knows |
| `grouppanel on\|off` | stop updating it |
| `grouppanel align on\|off` | the alignment strip under each member |
| `grouppanel show\|hide\|dock\|embed` | where the window lives |
| `grouppanel standalone on\|off` | stop the stock module's own group display |
| `grouppanel opacity <0-255>` | how solid the window is; 'default' follows the shared setting |

Each has its own `help` with the full list.

## Worth knowing

Installing this takes the group display over: the stock module's onGroup is stood
down through its own aard.config group switch, which is what its author put there for
it. 'grouppanel standalone off' hands it straight back.

One thing goes quiet with it. Their onGroup is also where aard.group[name] is seeded,
which their damage and party-heal triggers count into. Those triggers check the table
before touching it, so nothing breaks — the counters just stop, and nothing but their
own panel ever read them.

Their damage-share bar is not carried across: it needs the bracketed damage numbers
turned on, and it gives every member a free point of damage, so the percentages read
wrong until the first real hit lands.

## Config

Settings live in `<profile>/aardkit/group.lua`.
