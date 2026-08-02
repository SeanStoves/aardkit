# Search and Destroy

A searchable mob and area database carried over from the MUSHclient plugin, a three-tab panel that reads your quest, campaign and gquest targets from the MUD and walks you to one when you click it, and `ah <mob>` to follow the MUD's own hunt skill into areas your map has never seen.

## Install

1. Download `Search and Destroy.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `65` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `snd` | this list |
| `snd toggle` | show or hide the target panel |
| `snd cp \| quest \| gq` | ask the MUD for that target list |
| `(panel) quest tab` | time left on the quest, and time until the next one |
| `snd quest raw` | what gmcp.comm.quest actually sent |
| `snd go <n>` | speedwalk to target n |
| `(panel) click a target` | selects it; the buttons below act on it |
| `snd next` | walk to the first target listed |
| `ah <mob>` | auto-hunt: follow the MUD's hunt skill to it |
| `snd hunt <mob>` | same as `ah <mob>` — the alias just calls this |
| `aha` | cancel the hunt |
| `snd status` | row counts for mobs/areas/keywords, scan state |
| `snd mob <kw>` | rooms a mob was seen in, clickable [go] |
| `mobwhere <kw>` | same lookup, shorter alias |
| `(auto)` | a failed MUD 'where' falls back to the database by itself |
| `snd area [text]` | area list with level ranges and start rooms |
| `snd keywords` | read 'area keyword' so runto works for unmapped areas |
| `snd scan on\|off` | record mobs from room descriptions while moving (remembered) |
| `snd rewrite on\|off` | tidy 'cp check' into a clickable list (default on) |
| `snd dock\|embed\|hide\|show` | panel placement |

Each has its own `help` with the full list.

## Worth knowing

Targets tick off from the MUD's own "Congratulations, that was one of your CAMPAIGN
mobs!" line, which doesn't name the mob — so it reads back up the buffer for the
death line that came with it. Regular quests have no such line, so a quest target is
cleared by re-running `snd quest`. The mob database ships empty: fill it with
`snd scan on` or a migration.

The mob table learns three ways, and combat is the best of them: you only ever hit
the things that matter, and the damage line names them in the same short form the
campaign list uses. That needs no setting and no command.

The other two: `snd scan on` records what room descriptions name as
you walk, but most Aardwolf mobs have a custom long description - "An ettin berserker
charges wantonly around the dug-out encampment" - which that can't read. `con all`
names every mob in the room in the same short form the campaign and quest lists use,
so with Consider installed that fills the table properly too.

`ah <mob>` walks you room by room off the MUD's hunt skill, opening doors on the way.
It stops rather than guessing: portals, warded rooms, a locked door with no key, and
the three low-skill "the trail is confusing" readings all halt it, because under 85%
hunt the direction is a guess. It never runs while you're flagged AFK and gives up
after 120 rooms.

Clicking a target in the panel selects it and does nothing else; the buttons below
act on it, one press per command — [hunt] asks the MUD which way it is, [attack]
swings, [go] walks. Nothing chains into anything. When there are more targets
than fit, the arrows page through them, and the whole panel reflows as you drag
it - the buttons drop to two rows and the labels shorten rather than spilling out.

[go] walks you there and stops. If the area isn't in your map it falls
back on the MUD's own `runto <keyword>`, which needs Aylor recall or a runprefix, and
that is where it ends — nothing hunts or kills for you. Run `snd keywords` once to
learn the area list.

`cp check` gets swallowed and reprinted as a numbered list with a `[go]` and a
`[hunt]` beside each mob — `[go]` runs the same walk chain as the panel's rows,
`[hunt]` sends the MUD's own hunt skill. It reprints as a block rather than line by
line because the MUD lists the same mob twice when it still owes two of them, and
that only becomes knowable at the end. `hunt` wants one keyword rather than a whole
name, so the link guesses one — leading article off, trailing 'of'/'bent on' phrase
off, last word — and the tooltip shows what it will send. `snd rewrite off` leaves
the MUD's own lines alone.

## Config

Settings live in `<profile>/aardkit/snd.lua`.
