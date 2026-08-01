--[[
    Load every module .xml in this repo against a stubbed Mudlet API and drive
    what its aliases and triggers point at.
    Sean Stoves, 2026-08-01

        lua ci/harness.lua [repo-root]

    The development harness reads src/. This one reads the .xml files a PR would
    actually ship, which is the artefact anyone installs, and it finds the entry
    points in the XML rather than from a list - so a module added by a PR gets
    driven without anyone editing this file.

    It proves the code loads, the globals line up, and every alias and trigger
    points at a function that exists and survives being called. It is not a
    behaviour test and never claims to be.

    Run it under LuaJIT. Mudlet is LuaJIT 5.1, and things like \u{2014} escapes
    parse fine on 5.3+ and print literally in the client - a 5.4 run says OK to
    code that is visibly broken in Mudlet.
]]

local ROOT = arg[1] or "."
local HERE = (arg[0] or "ci/harness.lua"):gsub("[^/]*$", "")

STUB_HOME = os.getenv("STUB_HOME") or "/tmp/aardkit-ci"
os.execute('mkdir -p "' .. STUB_HOME .. '"')
dofile(HERE .. "mudlet_stub.lua")

---
-- reading the modules
---

local function slurp(p)
    local f = io.open(p, "r")
    if not f then return nil end
    local s = f:read("*a")
    f:close()
    return s
end

local ENT = {
    lt = "<", gt = ">", amp = "&", quot = '"', apos = "'",
}

local function unescape(s)
    return (s:gsub("&(#?%w+);", function(e)
        if ENT[e] then return ENT[e] end
        local n = e:match("^#(%d+)$")
        if n then return string.char(tonumber(n) % 256) end
        return "&" .. e .. ";"
    end))
end

-- Every <X ...> ... </X> block at any depth. Mudlet nests groups inside groups,
-- so this deliberately doesn't try to be a parser - it finds the open tag and
-- counts to the matching close.
local function blocks(xml, tag)
    local out, i = {}, 1
    local open = "<" .. tag .. "[ >]"
    while true do
        local s = xml:find(open, i)
        if not s then break end
        local depth, j = 0, s
        while true do
            local no = xml:find("<" .. tag .. "[ >]", j + 1)
            local nc = xml:find("</" .. tag .. ">", j + 1)
            if not nc then j = #xml; break end
            if no and no < nc then depth = depth + 1; j = no
            elseif depth == 0 then j = nc + #tag + 3; break
            else depth = depth - 1; j = nc end
        end
        out[#out + 1] = xml:sub(s, j)
        i = j
    end
    return out
end

local function scriptof(block)
    local body = block:match("<script>(.-)</script>")
    if not body or body == "" then return nil end
    return unescape(body)
end

local function listdir(path)
    local p = io.popen('ls -1 "' .. path .. '" 2>/dev/null')
    if not p then return {} end
    local out = {}
    for l in p:lines() do out[#out + 1] = l end
    p:close()
    return out
end

local mods = {}
for _, folder in ipairs(listdir(ROOT)) do
    local path = ROOT .. "/" .. folder .. "/" .. folder .. ".xml"
    local xml = slurp(path)
    if xml then
        local prio = tonumber(xml:match("aardkit%-priority:%s*(%d+)"))
        if not prio then
            print("FAIL  " .. folder .. "/" .. folder .. ".xml has no 'aardkit-priority' comment")
            os.exit(1)
        end
        mods[#mods + 1] = { folder = folder, xml = xml, prio = prio }
    end
end

if #mods == 0 then
    print("FAIL  no module .xml found under " .. ROOT)
    os.exit(1)
end

-- Priority is the install order the READMEs tell you to use, so it's also the
-- order these have to load in. Core is 1 and everything leans on it.
table.sort(mods, function(a, b)
    if a.prio ~= b.prio then return a.prio < b.prio end
    return a.folder < b.folder
end)

---
-- load
---

local loaded, failed = {}, {}

-- LuaJIT is 5.1, where load() takes a reader function and loadstring takes the
-- string. Getting this wrong is the exact class of bug this harness exists to
-- catch, so it would be embarrassing.
local compile = loadstring or load

for _, m in ipairs(mods) do
    for _, blk in ipairs(blocks(m.xml, "Script")) do
        local body = scriptof(blk)
        local name = blk:match("<name>(.-)</name>") or "?"
        if body then
            local label = m.folder .. "/" .. name
            local fn, err = compile(body, "@" .. label)
            if not fn then
                failed[#failed + 1] = label .. ": " .. tostring(err)
            else
                local ok, rerr = pcall(fn)
                if ok then loaded[#loaded + 1] = label
                else failed[#failed + 1] = label .. ": " .. tostring(rerr) end
            end
        end
    end
end

-- U.err is how the panel builder reports a nil call it swallowed in a pcall, so
-- anything arriving there is a failure and not a log line.
local reported = {}
if aardkit and aardkit.util then
    local real = aardkit.util.err
    aardkit.util.err = function(msg)
        reported[#reported + 1] = tostring(msg)
        if real then real(msg) end
    end
end

---
-- drive whatever the aliases and triggers point at
---

-- Run the alias/trigger body itself rather than picking the call apart. Picking
-- it apart got both of these wrong: 'on_who(line)' takes Mudlet's line global
-- and no capture at all, and 'who_done(tonumber(matches[2]))' wants a number
-- out of a capture that arrives as a string. Executing the body is what the
-- client does, so it can't disagree with the client.

-- Mudlet hands captures over as strings, always, so these are strings. A dispatcher
-- has to answer anything including nonsense; the ones that mean something take a
-- branch and the rest take the fallthrough.
local PROBE = {
    "", "status", "help", "list", "on", "off", "clear", "1", "zzznotaverb",
}

local drove, errors = 0, {}

for _, m in ipairs(mods) do
    for _, tag in ipairs({ "Alias", "Trigger" }) do
        for _, blk in ipairs(blocks(m.xml, tag)) do
            local body = scriptof(blk)
            local bname = blk:match("<name>(.-)</name>") or "?"
            if body then
                local label = string.format("%s %s '%s'", m.folder, tag:lower(), bname)
                local fn, cerr = compile(body, "@" .. label)
                if not fn then
                    errors[#errors + 1] = label .. " does not compile: " .. tostring(cerr)
                else
                    for _, p in ipairs(PROBE) do
                        matches = { p, p, p, p, p, p, p, p }
                        line = p
                        local ok, err = pcall(fn)
                        drove = drove + 1
                        if not ok then
                            errors[#errors + 1] = string.format("%s with %q: %s", label, p, tostring(err))
                        end
                    end
                end
            end
        end
    end
end

---
-- report
---

print(string.format("modules %d", #mods))
for _, m in ipairs(mods) do
    print(string.format("  %3d  %s", m.prio, m.folder))
end
print(string.format("scripts %d", #loaded))
print(string.format("drove   %d call(s)", drove))

local function dump(title, t)
    if #t == 0 then return end
    print(title)
    for _, e in ipairs(t) do print("  " .. e) end
end

dump("LOAD FAILURES:", failed)
dump("ERRORS REPORTED VIA U.err:", reported)
dump("RUNTIME ERRORS:", errors)

if #failed == 0 and #errors == 0 and #reported == 0 then
    print("OK - every module loads and every alias and trigger resolves")
    os.exit(0)
end
os.exit(1)
