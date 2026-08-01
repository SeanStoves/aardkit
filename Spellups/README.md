# Spellups

Tracks what's on you, what's blocked by a recovery and why the last cast failed, from Aardwolf's spell tag stream. The autocaster only ever types the MUD's own `spellup` and lets the MUD pick the spells. Separate opt-in extras, all off by default, do send individual casts — totem, eye of vigilance and a pre-cast list for wraith form.

## Install

1. Download `Spellups.xml`.
2. In Mudlet: **Toolbox → Module Manager → Install**, and pick the file.
3. Set **Priority** to `85` so it loads in the right order.
4. Tick **Sync** if you want changes saved back to the file and shared with your
   other profiles.
5. Save the profile (or restart).

Needs [Aardkit Core](../Aardkit%20Core/README.md) installed first
at priority 1 — it holds the shared `aardkit.util` / `aardkit.panel` / `aardkit.register`
that every module here builds on. Without it nothing else loads.


## Commands

| Command | Does |
|---|---|
| `spellup` | the panel: what is up, what just dropped |
| `spellup list` | every known spellup and its state |
| `spellup why <name>` | reason the last cast of it failed |
| `spellup slist` | re-read the skill table from the MUD |
| `spellup reclass` | re-read and diff against the old spellup set |
| `spellup sync` | read 'aff' to learn what is already running |
| `spellup auto` | autocast status and settings |
| `spellup auto on\|off` | enable or disable autocast |
| `spellup auto <n>` | fire once n spellups are down |
| `spellup auto cooldown <s>` | minimum seconds between fires |
| `spellup now` | send 'spellup' now; still blocked while AFK |
| `spellup warn 30\|10` | toggle expiry warnings |
| `spellup decay <secs>` | how long a fallen buff stays listed |
| `spellup totem\|eye\|aura\|wraith` | the opt-in extras, all off by default |

Each has its own `help` with the full list.

## Worth knowing

The autocaster types `spellup` and nothing else — the MUD decides which spells,
and it gates on mana, recoveries, nomagic rooms, sleeping and affects you already
have far better than a client could. The totem, eye, aura and wraith extras are the
exception: they do send individual commands, and all four ship off.

Nothing sends while you're flagged AFK, including `spellup now`.

`{affon}` only fires on a fresh cast, so the panel is blank at login until
`spellup sync` reads `aff` — which it does automatically once a cached skill table
exists.

## Config

Settings live in `<profile>/aardkit/spellups.lua`.
