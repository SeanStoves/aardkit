# Contributing

Patches welcome. A few things worth knowing before you start.

## What CI checks

Every pull request runs `ci/harness.lua` under LuaJIT against the `.xml` files
in the repo. It loads each module in priority order against a stubbed Mudlet
API, then executes every alias and trigger body with a spread of arguments.

It proves the code loads, the globals line up, and nothing points at a function
that doesn't exist. It is not a behaviour test and doesn't pretend to be.

You can run it yourself:

    luajit ci/harness.lua .

Use **LuaJIT**, not `lua5.4`. Mudlet is LuaJIT 5.1 and the gap bites: a
`\u{2014}` escape compiles on 5.3+ and prints literally in the client, so a
newer Lua will happily pass code that is visibly broken.

## Adding a module

Give it its own folder: `<Folder>/<Folder>.xml`, `<Folder>/README.md`, and
`<Folder>/module.json` with the Module Manager priority:

    { "priority": 55 }

Core is 1 and everything leans on it. CI reads the load order from module.json,
not the `<!-- aardkit-priority -->` comment in the XML — that comment is only
there for a human glancing at the file, and Mudlet's own writer strips it the
moment you tick **Sync**, which is a step our own install instructions tell you
to take. Without module.json the check fails rather than guessing.

## Saved state is executed, and that is deliberate

`U.load`/`U.save` go through Mudlet's `table.load`, which is `dofile()` - your
files under `<profile>/aardkit/` are run, not parsed. That is a considered
choice, not an oversight: writing one already needs write access to the profile
directory, and anything with that can edit the module scripts sitting beside
them, which are executed too.

The boundary that matters is data from elsewhere, and it is kept separate -
anything foreign (a shared loot file, a migration dump) is parsed with
`yajl.to_value` and never executed. Keep it that way. If you add a feature that
brings a state file in from another machine, this has to become JSON first.

## Don't infer MUD output from another plugin

This one has cost real time here more than once. If you're writing a trigger,
get the pattern from actual MUD output — a log or a screenshot — not from
another client's plugin. Plugins gag lines and reprint them in their own shape,
so a pattern copied from one matches that plugin's output rather than the MUD's.

The campaign parser matched 8% of real target lines for exactly this reason.

## Style

Match the file you're in. Comment the parts that aren't obvious and leave the
rest alone.
