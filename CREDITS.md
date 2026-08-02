# Credits

This set exists because other people solved these problems on MUSHclient first.
Where a module covers ground someone else covered they are named here, whether or
not a line of their code was involved — which, deliberately, it wasn't.

## Prior art

**Hadar** (Zzyzzyzzx) — <https://github.com/zzyzzyzzx/Hadar>

Spellups and Goals cover ground Hadar covered first. Spellups is written against
Aardwolf's published spell-tag protocol and the MUD's own `help spellup`; Goals is
written against `gmcp.char.worth`. Neither shares code, structure or naming with
his plugins. Worth noting where it landed: Hadar's own config delegated to the
MUD's `spellup` command once enough spells were down, and this module does the
same thing for the same reason — the MUD gates casting better than a client can.

**WinkleWinkle**, with later work by **Nokfah**, **Starling**, **Pwar**,
**Rauru** and **AardCrowley** — <https://github.com/AardCrowley/Search-and-Destroy>

Search and Destroy carries forward their mob/area database idea. The table shapes
match because they describe the same game data, which is fact rather than
expression; the query and display code is our own.

**Athlau**, maintained by **AardCrowley** —
<https://github.com/AardCrowley/Mushclient-Consider>

Mushclient-Consider is GPL-3.0, so a port of it would be a derivative work stuck
on GPL-3.0. Rather than carry that into an MIT set, Consider is being rewritten
from observed `consider` output instead of ported.

**The Gaardian Map Archives** — <https://maps.gaardian.com/>

MapExporter draws in Gaardian's house style on purpose — plain white boxes, black
borders, the room name across the top, a bar across a link for a door, and a stub
with a link marker instead of a line running across the map for a distant exit.
That visual language is theirs and it is what every Aardwolf player already reads
fluently. No Gaardian code or map data is used; the rooms come from your own
Mudlet map.

**Fiendish** and the Aardwolf MUSHclient package authors — the client package
these plugins originally ran inside.

**Aardwolf MUD** — for documenting the tag protocol publicly, which is what makes
an independent implementation possible at all.

## A note on what "inspired by" has to mean

It only holds if it's true. Copyright covers expression, not function: the tag
formats, the failure codes and the game's data shapes are facts and free to use.
Another author's code structure, algorithms as written, and naming are not.

The line held here: read prior plugins to learn *what the MUD sends*, then design
and write our own. Permission to release and recreate was granted by the upstream
authors on top of that.

## Licence

Everything in this repository is MIT. See LICENSE.
