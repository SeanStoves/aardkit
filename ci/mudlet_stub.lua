--[[
    A stubbed Mudlet API: every client function the modules call, doing nothing
    and counting the call. Enough for the code to load and run without a client.
    Sean Stoves, 2026-08-01

    Two harnesses load this. test/harness.lua drives src/ during development;
    ci/harness.lua drives the module XMLs a PR would actually ship. One stub so
    the two can't drift apart.

        STUB_HOME = "/tmp/whatever"       -- optional, defaults to "."
        dofile("mudlet_stub.lua")
]]

-- Mudlet runs Lua 5.1, where unpack is a global
unpack = unpack or table.unpack   -- luajit-ok: 5.1 global first, table.unpack only on newer Lua

local calls = {}
local function note(name)
    return function(...)
        calls[name] = (calls[name] or 0) + 1
        return nil
    end
end

---
-- output / core
---

-- Set STUB_HOME before loading to point saved state somewhere writable.
local HOME = STUB_HOME or os.getenv("STUB_HOME") or "."
function getMudletHomeDir() return HOME end
function getMainWindowSize() return 1637, 900 end
function getProfileName() return "aardwolf" end

cecho = note("cecho")
-- Recorded per window: the chat module's whole job is routing a message to the
-- right tabs, and a decho that goes nowhere makes that untestable.
DECHOED = {}
decho = function(a, b)
    calls.decho = (calls.decho or 0) + 1
    if b ~= nil then
        DECHOED[a] = DECHOED[a] or {}
        table.insert(DECHOED[a], tostring(b))
    end
end
dechoLink = note("dechoLink")
hecho = note("hecho")
startLogging = note("startLogging")
openUrl = note("openUrl")
echo = note("echo")
hecho = note("hecho")
cechoLink = note("cechoLink")
echoLink = note("echoLink")   -- the fallback path when dechoLink is missing
deleteLine = note("deleteLine")
selectCurrentLine = note("selectCurrentLine")
selectString = function() return 1 end
getFgColor = function() return 200, 180, 160 end
-- Mudlet's VGA default, so the palette check has something real to disagree with
local ANSI = { [0]={0,0,0},{128,0,0},{0,128,0},{128,128,0},{0,0,128},{128,0,128},
  {0,128,128},{192,192,192},{128,128,128},{255,0,0},{0,255,0},{255,255,0},
  {0,0,255},{255,0,255},{0,255,255},{255,255,255} }
getAnsiColor = function(i) local c = ANSI[i] or {0,0,0}; return c[1], c[2], c[3] end
copy = note("copy")
replace = note("replace")
-- Recorded per window, like decho: the chat captures copy a screen line into
-- several tabs and "where did it land" is the entire question.
APPENDED = {}
appendBuffer = function(win)
    calls.appendBuffer = (calls.appendBuffer or 0) + 1
    if win then
        APPENDED[win] = (APPENDED[win] or 0) + 1
    end
end
createBuffer = note("createBuffer")
clearWindow = note("clearWindow")
-- a console's own answer for how many lines fit; the pager reads it every repaint
getRowCount = function() return 24 end
getColumnCount = function() return 80 end
ansi2decho = function(t) return tostring(t) end
-- the wrap setting, which is what text actually breaks at
getWindowWrap = function() return 100 end
-- settable, so a test can put a line in front of the gag
CURRENT_LINE = ""
getCurrentLine = function() return CURRENT_LINE end
getLineCount = function() return 0 end
moveCursor = note("moveCursor")
moveCursorEnd = note("moveCursorEnd")
scrollTo = note("scrollTo")
scrollUp = note("scrollUp")
getScroll = function() return 0 end
getLastLineNumber = function() return 0 end
-- Recorded rather than merely counted: the pre-login send guard in core has to
-- be provable, and "did it go out, and when" is the whole question.
SENT = {}
send = function(what, echoBack)
    calls.send = (calls.send or 0) + 1
    SENT[#SENT + 1] = tostring(what)
    return nil
end
sendAll = note("sendAll")
enableTrigger = note("enableTrigger")
disableTrigger = note("disableTrigger")
disableScript = note("disableScript")
enableScript = note("enableScript")
disableKey = note("disableKey")
enableKey = note("enableKey")
killTrigger = note("killTrigger")
killTimer = note("killTimer")
-- Timers are recorded so a test can fire them. The confirmation window on a
-- cexit only matters when it EXPIRES, and a stub that swallowed the callback
-- made that unreachable.
TIMERS = {}
tempTimer = function(secs, fn)
    TIMERS[#TIMERS + 1] = { secs = secs, fn = fn }
    return #TIMERS
end
function TIMERS.fire(i)
    local t = TIMERS[i]
    if t and t.fn then t.fn() end
end
function TIMERS.fire_last()
    for i = #TIMERS, 1, -1 do
        if TIMERS[i].fn then TIMERS[i].fn(); return TIMERS[i].secs end
    end
end
tempLineTrigger = function() return 1 end
tempRegexTrigger = function() return 1 end
registerNamedTimer = note("registerNamedTimer")
deleteNamedTimer = note("deleteNamedTimer")
-- Handlers used to be dropped on the floor, which made every event-driven path
-- in the suite invisible to the harness: the http callbacks and the gmcp
-- watchers only ever run from one of these. That's how mark_synced() shipped
-- raising on every single upload - the code that calls it was never reached.
local handlers = {}

registerAnonymousEventHandler = function(ev, fn)
    handlers[ev] = handlers[ev] or {}
    local f = fn
    if type(fn) == "string" then
        -- Mudlet takes a dotted name too, resolved when it fires rather than now
        f = function(...)
            local o = _G
            for part in fn:gmatch("[^%.]+") do
                if type(o) ~= "table" then return end
                o = o[part]
            end
            if type(o) == "function" then return o(...) end
        end
    end
    handlers[ev][#handlers[ev] + 1] = f
    return #handlers[ev]
end

killAnonymousEventHandler = note("killAnonymousEventHandler")

function raiseEvent(ev, ...)
    for _, f in ipairs(handlers[ev] or {}) do f(ev, ...) end
end

-- What the next request answers with. A test that wants a failure or a
-- particular body sets these; the default is a reply that satisfies both the
-- auth flow and the upload flow.
http_reply = { body = '{"key":"harness-key","name":"Harness","merged":0,"upgraded":0}', fail = false }

-- Mudlet answers these asynchronously by raising sysPostHttpDone /
-- sysPostHttpError. Answering synchronously here is a lie about the timing but
-- an honest one about the shape, and it's the only way the callbacks run at all.
postHTTP = function(body, url, headers)
    if http_reply.fail then raiseEvent("sysPostHttpError", http_reply.body, url)
    else raiseEvent("sysPostHttpDone", url, http_reply.body) end
    return true
end

-- Aardwolf's tag channel. Mudlet wraps the IAC SB 102 ... IAC SE around
-- whatever payload you hand it.
sendTelnetChannel102 = note("sendTelnetChannel102")

-- so a test can assert an out-of-band negotiation did NOT happen
function calls_count(name) return calls[name] or 0 end

getHTTP = function(url, headers)
    if http_reply.fail then raiseEvent("sysGetHttpError", http_reply.body, url)
    else raiseEvent("sysGetHttpDone", url, http_reply.body) end
    return true
end

---
-- map api
--
-- A real little map, not a shelf of stubs that answer politely.
--
-- The old version had roomExists() return true for everything, which means the
-- mapping engine would have found every room already present, created nothing,
-- and the harness would have called that a pass. Same trap as the db stub and
-- the http stub before it: a permissive stub is worse than no stub, because it
-- turns "untested" into "tested, green".
--
-- So this holds rooms, areas, coordinates, exits, stubs and user data, and the
-- harness asserts against what actually ended up in it.
---

MAP = { rooms = {}, areas = {}, envcolor = {}, nextarea = 0, centered = nil }

local EXITNUM = { n = 1, ne = 2, nw = 3, e = 4, w = 5, s = 6, se = 7, sw = 8, u = 9, d = 10 }
local EXITNAME = { "n", "ne", "nw", "e", "w", "s", "se", "sw", "u", "d" }
for long, short in pairs({ north = "n", northeast = "ne", northwest = "nw", east = "e",
                           west = "w", south = "s", southeast = "se", southwest = "sw",
                           up = "u", down = "d" }) do
    EXITNUM[long] = EXITNUM[short]
end

local function dirnum(d)
    if type(d) == "number" then return d end
    return EXITNUM[tostring(d or ""):lower()]
end

function MAP.reset()
    MAP.rooms, MAP.areas, MAP.envcolor, MAP.nextarea, MAP.centered = {}, {}, {}, 0, nil
end

function MAP.room(id) return MAP.rooms[tonumber(id)] end

roomExists = function(id) return MAP.rooms[tonumber(id)] ~= nil end

addRoom = function(id)
    id = tonumber(id)
    if not id or MAP.rooms[id] then return false end
    MAP.rooms[id] = { id = id, name = "", area = -1, x = 0, y = 0, z = 0, env = 0,
                      exits = {}, stubs = {}, special = {}, doors = {}, user = {} }
    return true
end

deleteRoom = function(id) MAP.rooms[tonumber(id)] = nil end

addAreaName = function(name)
    name = tostring(name or "")
    for id, n in pairs(MAP.areas) do if n == name then return id end end
    MAP.nextarea = MAP.nextarea + 1
    MAP.areas[MAP.nextarea] = name
    return MAP.nextarea
end

deleteArea = function(id) MAP.areas[tonumber(id)] = nil end

-- These are NOT the same table, and aliasing them here is how six call sites
-- shipped reading Swap backwards. getAreaTable is name -> id; getAreaTableSwap
-- is id -> name. Checked against Mudlet's own generic_mapper, which does
-- `getAreaTableSwap()[areaid]` to get a name and reverses getAreaTable() to
-- build the same thing.
getAreaTable = function()
    local t = {}
    for id, n in pairs(MAP.areas) do t[n] = id end
    return t
end
getAreaTableSwap = function()
    local t = {}
    for id, n in pairs(MAP.areas) do t[id] = n end
    return t
end

getAreaRooms = function(aid)
    aid = tonumber(aid)
    local out = {}
    for id, r in pairs(MAP.rooms) do if r.area == aid then out[#out + 1] = id end end
    table.sort(out)
    return out
end

getRooms = function()
    local t = {}
    for id, r in pairs(MAP.rooms) do t[id] = r.name end
    return t
end

setRoomName = function(id, n) local r = MAP.room(id); if r then r.name = tostring(n or "") end end
getRoomName = function(id) local r = MAP.room(id); return r and r.name or "" end

setRoomArea = function(id, a) local r = MAP.room(id); if r then r.area = tonumber(a) or -1 end end
getRoomArea = function(id) local r = MAP.room(id); return r and r.area or nil end

setRoomEnv = function(id, e) local r = MAP.room(id); if r then r.env = tonumber(e) or 0 end end
getRoomEnv = function(id) local r = MAP.room(id); return r and r.env or 0 end

setRoomCoordinates = function(id, x, y, z)
    local r = MAP.room(id)
    if r then r.x, r.y, r.z = tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0 end
end
getRoomCoordinates = function(id)
    local r = MAP.room(id)
    if not r then return nil end
    return r.x, r.y, r.z
end

getRoomsByPosition = function(aid, x, y, z)
    aid, x, y, z = tonumber(aid), tonumber(x), tonumber(y), tonumber(z)
    local out = {}
    for id, r in pairs(MAP.rooms) do
        if r.area == aid and r.x == x and r.y == y and r.z == z then out[#out + 1] = id end
    end
    table.sort(out)
    return out
end

setExit = function(from, to, d)
    local r, n = MAP.room(from), dirnum(d)
    if not (r and n and MAP.room(to)) then return false end
    r.exits[n] = tonumber(to)
    r.stubs[n] = nil
    return true
end

setExitStub = function(id, d, on)
    local r, n = MAP.room(id), dirnum(d)
    if not (r and n) then return false end
    if on == false then r.stubs[n] = nil else r.stubs[n] = true end
    return true
end

getExitStubs = function(id)
    local r = MAP.room(id)
    local out = {}
    if r then for n in pairs(r.stubs) do out[#out + 1] = n end end
    table.sort(out)
    return out
end

getRoomExits = function(id)
    local r = MAP.room(id)
    local t = {}
    if r then for n, to in pairs(r.exits) do t[EXITNAME[n] or tostring(n)] = to end end
    return t
end

addSpecialExit = function(from, to, cmd)
    local r = MAP.room(from)
    if not (r and MAP.room(to)) then return false end
    r.special[tostring(cmd)] = tonumber(to)
    return true
end
-- The two are NOT the same shape, and this stub used to return the convenient
-- one from both names. Mudlet:
--   getSpecialExits(id)      -> { [destRoomID] = { [command] = lockFlag } }
--   getSpecialExitsSwap(id)  -> { [command]    = destRoomID }
-- Six call sites read the first as if the value were the command string, so a
-- walk through a custom exit sent the MUD "table: 0x8bbcd3680" and got told off.
-- Checked against Mudlet's own generic_mapper, which does
-- `for cmd,room in pairs(getSpecialExitsSwap(k))`.
getSpecialExits = function(id)
    local r = MAP.room(id)
    local t = {}
    if r then for cmd, to in pairs(r.special) do t[to] = { [cmd] = "0" } end end
    return t
end
getSpecialExitsSwap = function(id)
    local r = MAP.room(id)
    local t = {}
    if r then for cmd, to in pairs(r.special) do t[cmd] = to end end
    return t
end
removeSpecialExit = function(id, cmd)
    local r = MAP.room(id)
    if r then r.special[tostring(cmd)] = nil end
end
clearSpecialExits = function(id) local r = MAP.room(id); if r then r.special = {} end end

setDoor = function(id, d, st)
    local r = MAP.room(id)
    if r then r.doors[tostring(d)] = tonumber(st) or 0 end
    return true
end
getDoors = function(id) local r = MAP.room(id); return r and r.doors or {} end

setRoomUserData = function(id, k, v) local r = MAP.room(id); if r then r.user[k] = tostring(v) end end
getRoomUserData = function(id, k) local r = MAP.room(id); return (r and r.user[k]) or "" end
clearRoomUserData = function(id, k) local r = MAP.room(id); if r then r.user[k] = nil end end

searchRoomUserData = function(key, want)
    local out = {}
    for id, r in pairs(MAP.rooms) do
        local v = r.user[key]
        if v and v:find(tostring(want), 1, true) then out[#out + 1] = id end
    end
    table.sort(out)
    return out
end

searchRoom = function(text)
    local out = {}
    for id, r in pairs(MAP.rooms) do
        if r.name:lower():find(tostring(text):lower(), 1, true) then out[id] = r.name end
    end
    return out
end

setCustomEnvColor = function(e, r, g, b, a) MAP.envcolor[tonumber(e)] = { r, g, b, a } end

-- appearance. Real values, because the style presets snapshot what was there
-- before they change it and 'mapper style restore' has to put it back.
MAP.config = {
    mapRoundRooms = true, mapShowRoomBorders = true, mapShowGrid = false,
    showRoomIdsOnMap = false, show3dMapView = false, showUpperLowerLevels = false,
    mapRoomSize = 5, mapExitSize = 10,
}
setConfig = function(k, v) MAP.config[k] = v; return true end
getConfig = function(k) return MAP.config[k] end
setGridMode = function(aid, on) MAP.grid = MAP.grid or {}; MAP.grid[tonumber(aid)] = on and true or nil; return true end
getGridMode = function(aid) return (MAP.grid or {})[tonumber(aid)] and true or false end
setRoomChar = function(id, c) local r = MAP.room(id); if r then r.char = tostring(c or "") end end
getRoomChar = function(id) local r = MAP.room(id); return r and r.char or "" end
setRoomCharColor = note("setRoomCharColor")
highlightRoom = function(id, ...) local r = MAP.room(id); if r then r.lit = true end; return true end
unHighlightRoom = function(id) local r = MAP.room(id); if r then r.lit = nil end; return true end
getRoomLit = function(id) local r = MAP.room(id); return r and r.lit and true or false end
setMapBackgroundColor = note("setMapBackgroundColor")
setMapRoomExitsColor = note("setMapRoomExitsColor")
centerview = function(id) MAP.centered = tonumber(id) end
deleteMap = function() MAP.reset() end
saveMap = function() return true end
getPlayerRoom = function() return MAP.centered or 1234 end
-- getPath writes both globals as a side effect; the path is what lets the
-- walker ask "is there a custom exit between these two rooms" per step.
speedWalkPath = {}
getPath = function(from, to)
    speedWalkDir  = { "n", "e" }
    speedWalkPath = { 1235, tonumber(to) or 1234 }
    return true
end
doSpeedWalk = note("doSpeedWalk")
speedWalkDir = {}
getTime = function() return "20260802-1300" end
-- Mudlet splits input on this before any alias runs; readable, not writable.
getCommandSeparator = function() return ";" end
setLabelWheelCallback = note("setLabelWheelCallback")
-- The ORDER, not just the count. note() only tallies calls, and z-order is
-- entirely about sequence: raising a panel's children in hash order re-rolls
-- their stacking, which is how an opaque backdrop kept surfacing above the tabs
-- it was meant to sit behind.
RAISED = {}
raiseWindow = function(name)
    calls.raiseWindow = (calls.raiseWindow or 0) + 1
    RAISED[#RAISED + 1] = tostring(name)
end
lowerWindow = note("lowerWindow")
setMapZoom = note("setMapZoom")
getMapZoom = function() return 3 end

-- A couple of rooms to stand in, so the command paths that read the map have
-- something to read. Midgaard is area 1 because everything else assumes it is.
addAreaName("Midgaard")
addRoom(1234); setRoomName(1234, "Somewhere"); setRoomArea(1234, 1); setRoomCoordinates(1234, 0, 0, 0)
addRoom(1235); setRoomName(1235, "Somewhere Else"); setRoomArea(1235, 1); setRoomCoordinates(1235, 0, 2, 0)
setExit(1234, 1235, 1)
setExit(1235, 1234, 6)

matches = { "", "", "", "" }
gmcp = { room = { info = { num = 1234, name = "Somewhere", zone = "midgaard" } },
         char = { base = { name = "Solao" }, status = { state = 3 },
                  worth = { qp = "1644", tp = "5", gold = "942153", bank = "12120000", trains = "0", pracs = "425" } } }

---
-- lfs / io.exists
---

lfs = {
  -- actually make it. Returning true without creating the directory meant every
  -- save silently failed against a path that didn't exist, and the harness
  -- blamed the code.
  mkdir = function(d)
    if os.execute('mkdir -p "' .. d .. '" 2>/dev/null') then return true end
    return nil, "mkdir failed"
  end,
  dir = function(d)
    local p = io.popen('ls -1 "'..d..'" 2>/dev/null')
    local t = {}
    for l in p:lines() do t[#t+1] = l end
    p:close()
    local i = 0
    return function() i = i + 1; return t[i] end
  end,
  attributes = function() return 1024 end,
}
io.exists = function(p)
    local fh = io.open(p, "r")
    if fh then fh:close(); return true end
    return false
end

---
-- table.save / table.load (Mudlet's persistence)
---

-- Real files, not an in-memory table keyed by path. The in-memory version
-- couldn't model a rename, so it silently defeated U.save's atomic write - the
-- data went to <path>.new and the load found nothing, and the harness reported
-- a merge bug that was entirely the stub's.
local function pickle(v, out, indent)
    local t = type(v)
    if t == "number" or t == "boolean" then
        out[#out + 1] = tostring(v)
    elseif t == "string" then
        out[#out + 1] = string.format("%q", v)
    elseif t == "table" then
        out[#out + 1] = "{\n"
        for k, val in pairs(v) do
            out[#out + 1] = indent .. "  ["
            pickle(k, out, indent .. "  ")
            out[#out + 1] = "] = "
            pickle(val, out, indent .. "  ")
            out[#out + 1] = ",\n"
        end
        out[#out + 1] = indent .. "}"
    else
        out[#out + 1] = "nil"
    end
end

function table.save(path, tbl)
    local fh, msg = io.open(path, "w")
    if not fh then return nil, msg end
    local out = { "return " }
    pickle(tbl, out, "")
    fh:write(table.concat(out))
    fh:close()
end

function table.load(path, tbl)
    local fn = (loadstring or load)("return " .. (function()
        local fh = io.open(path, "r")
        if not fh then return "nil" end
        local s = fh:read("*a"); fh:close()
        return "(function() " .. s .. " end)()"
    end)())
    if not fn then return false end
    local ok, src = pcall(fn)
    if not ok or type(src) ~= "table" then return false end
    for k, v in pairs(src) do tbl[k] = v end
    return true
end

---
-- yajl
---

-- These returned "{}" and {} respectively, which meant the auth reply never had
-- a key in it, so 'loot upload' stopped at "not authenticated" and every line
-- past that point was untested. It also meant row encoding was never exercised
-- at all - a row yajl can't encode would have sailed through the harness.
-- Small, but real both ways.
local function esc(s)
    return (s:gsub('[%c"\\]', function(c)
        local m = { ['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n',
                    ['\r'] = '\\r', ['\t'] = '\\t', ['\b'] = '\\b', ['\f'] = '\\f' }
        return m[c] or string.format("\\u%04x", c:byte())
    end))
end

local function encode(v)
    local t = type(v)
    if v == nil then return "null" end
    if t == "boolean" then return tostring(v) end
    if t == "number" then
        if v ~= v or v == math.huge or v == -math.huge then
            error("cannot encode " .. tostring(v) .. " as json")
        end
        -- no math.type on 5.1; an integral float still has to print as an int
        if v == math.floor(v) and math.abs(v) < 1e15 then return string.format("%d", v) end
        return string.format("%.14g", v)
    end
    if t == "string" then return '"' .. esc(v) .. '"' end
    if t ~= "table" then error("cannot encode a " .. t .. " as json") end
    local n = 0
    for _ in pairs(v) do n = n + 1 end
    if n == #v then
        local out = {}
        for i, x in ipairs(v) do out[i] = encode(x) end
        return "[" .. table.concat(out, ",") .. "]"
    end
    local keys = {}
    for k in pairs(v) do
        if type(k) ~= "string" then error("json object keys must be strings, got " .. type(k)) end
        keys[#keys + 1] = k
    end
    table.sort(keys)
    local out = {}
    for i, k in ipairs(keys) do out[i] = '"' .. esc(k) .. '":' .. encode(v[k]) end
    return "{" .. table.concat(out, ",") .. "}"
end

local function decode(s)
    local i = 1
    local function ws() i = s:find("[^ \t\r\n]", i) or #s + 1 end
    local val
    function val()
        ws()
        local c = s:sub(i, i)
        if c == "{" then
            i = i + 1; local o = {}
            ws(); if s:sub(i, i) == "}" then i = i + 1; return o end
            while true do
                ws(); local k = val(); ws()
                if s:sub(i, i) ~= ":" then error("json: expected ':' at " .. i) end
                i = i + 1; o[k] = val(); ws()
                local d = s:sub(i, i); i = i + 1
                if d == "}" then return o end
                if d ~= "," then error("json: expected ',' or '}' at " .. (i - 1)) end
            end
        elseif c == "[" then
            i = i + 1; local a = {}
            ws(); if s:sub(i, i) == "]" then i = i + 1; return a end
            while true do
                a[#a + 1] = val(); ws()
                local d = s:sub(i, i); i = i + 1
                if d == "]" then return a end
                if d ~= "," then error("json: expected ',' or ']' at " .. (i - 1)) end
            end
        elseif c == '"' then
            local out = {}
            i = i + 1
            while true do
                local ch = s:sub(i, i)
                if ch == "" then error("json: unterminated string") end
                if ch == '"' then i = i + 1; break end
                if ch == "\\" then
                    local e = s:sub(i + 1, i + 1)
                    local m = { n = "\n", r = "\r", t = "\t", b = "\b", f = "\f",
                                ['"'] = '"', ["\\"] = "\\", ["/"] = "/" }
                    if m[e] then out[#out + 1] = m[e]; i = i + 2
                    elseif e == "u" then
                        -- \uXXXX: ascii range only, which is all this ever sees
                        local cp = tonumber(s:sub(i + 2, i + 5), 16) or 63
                        out[#out + 1] = (cp < 128) and string.char(cp) or "?"
                        i = i + 6
                    else error("json: bad escape \\" .. e) end
                else out[#out + 1] = ch; i = i + 1 end
            end
            return table.concat(out)
        else
            local lit = s:match("^true", i) or s:match("^false", i) or s:match("^null", i)
            if lit then
                i = i + #lit
                return lit == "true" and true or (lit == "false" and false or nil)
            end
            local num = s:match("^%-?%d+%.?%d*[eE]?[%+%-]?%d*", i)
            if not num or num == "" then error("json: unexpected input at " .. i) end
            i = i + #num
            return tonumber(num)
        end
    end
    local v = val()
    return v
end

yajl = {
    to_string = function(v) return encode(v) end,
    to_value  = function(s) return decode(tostring(s)) end,
}

---
-- Geyser
---

-- Containers carry a real SIZE. Without one, get_width() falls through the
-- metatable, returns the widget table, and U.px() reads that as 0 - so every
-- layout() in this codebase starts with `if w < 40 then return end` and does
-- nothing at all under test. Two modules' worth of geometry was never once
-- exercised, and the first test written against it failed for that reason
-- rather than the one it was checking.
local function widget(extra)
    local w = {}
    setmetatable(w, { __index = function() return function() return w end end })
    for k, v in pairs(extra or {}) do w[k] = v end
    w.get_width  = function(self) return tonumber((tostring(self.width  or 0):gsub("px", ""))) or 0 end
    w.get_height = function(self) return tonumber((tostring(self.height or 0):gsub("px", ""))) or 0 end
    return w
end

-- what a panel gets when it asks a container how big it is
local function sized(cons, fallbackw, fallbackh)
    local w = tonumber((tostring((cons and cons.width)  or ""):gsub("px", ""))) or fallbackw
    local h = tonumber((tostring((cons and cons.height) or ""):gsub("px", ""))) or fallbackh
    return w, h
end

CONTAINERS = {}

local function ctor(kind)
    return { new = function(_, cons, parent)
        local cw, ch = sized(cons, 800, 600)
        local w = widget({ name = (cons and cons.name) or kind, width = cw, height = ch })
        w.text = widget({})
        -- the CONSTRUCTOR args, because x/width are the whole of the frame fix
        -- and a widget that reports its own rounded size cannot show them
        CONTAINERS[#CONTAINERS + 1] = cons or {}
        CONTAINERS.last = cons or {}
        return w
    end }
end

-- Recorded, because Core.Supports.Set REPLACES the server's list: a Set that
-- names fewer packages than someone else already asked for is a silent
-- reduction, and there is nothing on screen to say so.
BORDERS = {}

-- Recorded: "frame bottom" is only above the command line if the border is
-- actually reserved, and a no-op stub cannot tell that from a container that
-- simply sits on top of the output.
function setBorderBottom(n) BORDERS.bottom = n end
function setBorderTop(n)    BORDERS.top    = n end
function setBorderLeft(n)   BORDERS.left   = n end
function setBorderRight(n)  BORDERS.right  = n end

-- Readable, because measuring the frame strip against them is the whole fix.
-- Mudlet 4.22 registers these in C++; they appear nowhere in mudlet-lua, which
-- is why grepping the Lua for them finds nothing.
function getBorderBottom() return BORDERS.bottom or 0 end
function getBorderTop()    return BORDERS.top    or 0 end
function getBorderLeft()   return BORDERS.left   or 0 end
function getBorderRight()  return BORDERS.right  or 0 end

SCROLLBARS, BGCOLOR = {}, {}
-- Recorded per window: "no scrollbar" and "opaque" are both claims a no-op stub
-- cannot check, and both were asked for explicitly.
function enableScrollBar(n)  SCROLLBARS[tostring(n)] = true end
function disableScrollBar(n) SCROLLBARS[tostring(n)] = false end
function setBackgroundColor(n, r, g, b, a) BGCOLOR[tostring(n)] = { r, g, b, a } end

STYLESHEETS = {}
-- The stylesheet TEXT, because "opaque" here is a CSS validity question:
-- rgba() alpha out of range makes Qt discard the whole declaration, and a stub
-- that only records that setStyleSheet was called cannot see that.
function setUserWindowStyleSheet(n, css) STYLESHEETS[tostring(n)] = tostring(css) end

APPSTYLE = nil
function setAppStyleSheet(css, tag) APPSTYLE = tostring(css) end

LOGGED = {}

-- Records what it was actually GIVEN. A no-op stub cannot tell "logged the
-- line" from "logged the string 'main'", which is exactly what shipped.
function appendLog(...) LOGGED[#LOGGED + 1] = table.concat({ ... }, "\1") end

ENCODING = nil
function setServerEncoding(e) ENCODING = e end

USERWINDOWS = {}

GMCP_SENT = {}

function sendGMCP(msg)
    GMCP_SENT[#GMCP_SENT + 1] = tostring(msg)
end

GAUGES = {}

Geyser = {
    add = function() return true end,
    -- A Gauge carries .back and .front sub-widgets that get styled separately,
    -- and setValue is RECORDED: a bar showing the wrong number is worse than no
    -- bar, and that is unanswerable if the call goes nowhere.
    -- show/hide are RECORDED too. The widget metatable answers every unknown
    -- method with a no-op, so `check("the row is hidden", ...)` against a plain
    -- widget passes whether or not anything hid it - the permissive-stub trap
    -- this file has fallen into seven times. A row that stays on screen after
    -- its member leaves the group is the bug; it needs to be observable.
    Gauge = { new = function(_, cons, parent)
        local nm = (cons and cons.name) or "Gauge"
        local w = widget({ name = nm })
        w.back, w.front, w.text = widget({}), widget({}), widget({})
        w.back.setStyleSheet  = function(self, c) self.css = c end
        w.front.setStyleSheet = function(self, c) self.css = c end
        -- built in place, so setValue MUTATES rather than replacing: replacing
        -- would drop .w and .shown on the first update
        GAUGES[nm] = { w = w, shown = true }
        w.setValue = function(self, cur, max, text)
            local e = GAUGES[nm]
            e.cur, e.max, e.text = cur, max, tostring(text or "")
            return self
        end
        w.hide = function(self) GAUGES[nm].shown = false; return self end
        w.show = function(self) GAUGES[nm].shown = true;  return self end
        return w
    end },
    Label = ctor("Label"),
    MiniConsole = ctor("MiniConsole"),
    UserWindow = { new = function(_, cons)
        local cw, ch = sized(cons, 800, 600)
        local w = widget({ name = (cons and cons.name) or "UserWindow", width = cw, height = ch })
        w.text = widget({})
        w.setDockPosition = function(self, pos) USERWINDOWS.last_setdock = pos; return self end
        USERWINDOWS[#USERWINDOWS + 1] = cons or {}
        USERWINDOWS.last = cons or {}
        return w
    end },
    Container = ctor("Container"),
    -- Real Mudlet ships GeyserScrollBox.lua, so code may reach for it. It is
    -- still guarded at the call site, because older builds don't have it.
    ScrollBox = ctor("ScrollBox"),
    Mapper = ctor("Mapper"),
}

Adjustable = {
    Container = {
        new = function(_, cons)
            local cw, ch = sized(cons, 800, 600)
            return widget({ name = cons and cons.name or "ac", width = cw, height = ch })
        end,
        saveAll = note("saveAll"),
        loadAll = note("loadAll"),
    },
}

---
-- db: layer
---

local Sheet = {}
-- Mudlet's sheet __index asserts on any name that isn't a declared column:
--
--   local field = db.__schema[db_name][sht_name]['columns'][f_name]
--   if assert(field ~= nil, "Attempt to access field '%s' which does not exist") then
--
-- and _row_id is deliberately NOT in schema.columns - it's the implicit primary
-- key. So `db:eq(sheet._row_id, id)` doesn't build a bad query, it raises.
--
-- This handed back a marker for anything asked of it, which let two real bugs
-- through the harness: mark_synced() raised on every upload inside the http
-- callback where you never saw it, and 'loot clear' raised the same way. Third
-- time a too-agreeable stub has hidden something, so it errors like the real
-- one now. Address rows by _row_id with a hand-built "_row_id = n" string, the
-- way Mudlet's own db:delete does.
Sheet.__index = function(t, k)
    local v = rawget(t, k)
    if v then return v end
    if k == "_row_id" then
        error("Attempt to access field '_row_id' which does not exist (in sheet '"
            .. tostring(rawget(t, "__name")) .. "') - it's the implicit primary key,"
            .. " build the query by hand", 2)
    end
    local cols = db.__cols and db.__cols[t]
    if cols and next(cols) and cols[k] == nil then
        error("Attempt to access field '" .. tostring(k) .. "' which does not exist (in sheet '"
            .. tostring(rawget(t, "__name")) .. "')", 2)
    end
    return { __col = k, __sheet = rawget(t, "__name") }
end

db = {
    __data = {},
    __cols = {},          -- sheet -> column defaults, so a seeded row looks real
    create_returns_handle = true,
    create = function(self, name, sheets)
        db[name] = {}
        for sname, cols in pairs(sheets) do
            local s = setmetatable({ __name = name .. "." .. sname }, Sheet)
            db[name][sname] = s
            db.__data[s] = {}
            -- Real sqlite hands back the schema default for a column nobody set,
            -- never nil. Keep those so test rows can't be less complete than the
            -- rows the client actually produces.
            local d = {}
            for k, v in pairs(cols) do
                if k:sub(1, 1) ~= "_" then d[k] = v end
            end
            db.__cols[s] = d
        end
        return db[name]
    end,

    -- a row carrying every column, with the caller's values laid over the
    -- schema defaults. For harnesses, not something Mudlet has.
    __seed = function(sheet, row)
        if not (sheet and db.__data[sheet]) then return end
        local r = {}
        for k, v in pairs(db.__cols[sheet] or {}) do r[k] = v end
        for k, v in pairs(row or {}) do r[k] = v end
        r._row_id = 1
        db.__data[sheet] = { r }
        return r
    end,
    add = function(self, sheet, row)
        local t = db.__data[sheet]
        if not t then error("db:add on unknown sheet") end
        -- sqlite fills a column nobody set with its schema default, never nil.
        -- Skipping that left every row with synced = nil, so the "what's still
        -- to sync" query matched nothing and the whole upload path short-
        -- circuited on "nothing new to upload" - a test that ran, passed, and
        -- exercised none of it.
        for k, v in pairs(db.__cols[sheet] or {}) do
            if row[k] == nil then row[k] = v end
        end
        row._row_id = #t + 1
        t[#t + 1] = row
        return row._row_id
    end,
    -- Actually filter. This used to return every row whatever you asked for,
    -- which meant an upsert's "have I seen this already" always said yes and a
    -- second distinct mob looked like a duplicate of the first. A stub that
    -- answers differently from the database is worse than no stub - that is
    -- exactly how the db:update signature bug survived.
    fetch = function(self, sheet, where)
        local rows = db.__data[sheet] or {}
        if type(where) ~= "table" or not where.op then return rows end
        local function match(row, q)
            if q.op == "and" then
                for _, p in ipairs(q.parts or {}) do if not match(row, p) then return false end end
                return true
            elseif q.op == "or" then
                for _, p in ipairs(q.parts or {}) do if match(row, p) then return true end end
                return false
            elseif q.op == "eq" then
                return tostring(row[q.col]) == tostring(q.v)
            elseif q.op == "like" then
                -- SQL's wildcard is % and so is Lua's escape character, so the
                -- wildcards come out first, everything left gets escaped as a
                -- literal, and then they go back in as .*
                local v = tostring(q.v):lower():gsub("%%", "\1")
                v = v:gsub("[%^%$%(%)%.%[%]%*%+%-%?%%]", "%%%0")
                v = v:gsub("\1", ".*")
                return tostring(row[q.col] or ""):lower():find(v) ~= nil
            elseif q.op == "gt" then return (tonumber(row[q.col]) or 0) > (tonumber(q.v) or 0)
            elseif q.op == "lt" then return (tonumber(row[q.col]) or 0) < (tonumber(q.v) or 0)
            end
            return true
        end
        local out = {}
        for _, r in ipairs(rows) do if match(r, where) then out[#out + 1] = r end end
        return out
    end,

    -- Hold the real contract, not a permissive one. This used to be
    -- update(self, sheet, fields, where) returning 0, which is why ten call
    -- sites passed a third argument that Mudlet doesn't have and the harness
    -- said OK to writes that would have asserted in the client. Mudlet's is
    -- db:update(sheet, tbl) and it asserts on tbl._row_id (DB.lua:1411).
    update = function(self, sheet, tbl, extra)
        if extra ~= nil then error("db:update takes (sheet, tbl) - no query argument", 2) end
        if type(tbl) ~= "table" or not tbl._row_id then
            error("db:update needs tbl._row_id - fetch the row first", 2)
        end
        return 0
    end,
    -- db:set(field, value, query) - one column, many rows
    -- Checked its argument was a column and then did nothing, so every
    -- "mark these rows as done" in the suite was a no-op the tests couldn't
    -- see. It writes now, and understands the raw WHERE strings the code has to
    -- build by hand for _row_id.
    set = function(self, field, value, query)
        if type(field) ~= "table" or not field.__col then
            error("db:set takes a column (sheet.column), not a sheet", 2)
        end
        local sheet
        for s in pairs(db.__data) do
            if rawget(s, "__name") == field.__sheet then sheet = s; break end
        end
        if not sheet then return 0 end
        local rows = db.__data[sheet]

        local want
        if query == nil then
            want = function() return true end
        elseif type(query) == "string" then
            local list = query:match("^_row_id%s+IN%s*%((.-)%)$")
            local one  = query:match("^_row_id%s*=%s*(%d+)$")
            if list then
                local ids = {}
                for n in list:gmatch("%d+") do ids[n] = true end
                want = function(r) return ids[tostring(r._row_id)] end
            elseif one then
                want = function(r) return tostring(r._row_id) == one end
            elseif query:match("^%s*1%s*=%s*1%s*$") then
                want = function() return true end
            else
                error("stub db:set doesn't understand the raw query: " .. query)
            end
        elseif type(query) == "table" and query.op then
            local hit = {}
            for _, r in ipairs(db:fetch(sheet, query)) do hit[r] = true end
            want = function(r) return hit[r] end
        else
            error("db:set got a query it can't read")
        end

        local n = 0
        for _, r in ipairs(rows) do
            if want(r) then r[field.__col] = value; n = n + 1 end
        end
        return n
    end,
    -- Returning 0 and deleting nothing meant 'loot clear' could be completely
    -- broken and still pass. Mudlet takes a query table, a row id, a result
    -- table, or a raw WHERE string - the string being how you say "all of them",
    -- since there's no field object for _row_id to build a query with.
    delete = function(self, sheet, where)
        local t = db.__data[sheet]
        if not t then error("db:delete on unknown sheet") end
        local before = #t
        if type(where) == "string" then
            local id = where:match("^_row_id%s*=%s*(%d+)$")
            if id then
                for i, r in ipairs(t) do
                    if tostring(r._row_id) == id then table.remove(t, i); break end
                end
            elseif where:match("^%s*1%s*=%s*1%s*$") then
                for i = #t, 1, -1 do t[i] = nil end
            else
                error("stub db:delete doesn't understand the raw query: " .. where)
            end
        elseif type(where) == "number" then
            for i, r in ipairs(t) do
                if r._row_id == where then table.remove(t, i); break end
            end
        elseif type(where) == "table" and where._row_id then
            for i, r in ipairs(t) do
                if r._row_id == where._row_id then table.remove(t, i); break end
            end
        elseif type(where) == "table" and where.op then
            local keep = {}
            for _, r in ipairs(db:fetch(sheet, where)) do keep[r] = true end
            for i = #t, 1, -1 do if keep[t[i]] then table.remove(t, i) end end
        else
            error("db:delete needs a query")
        end
        return before - #t
    end,
    -- carry the column and value, so fetch above can honour them
    eq   = function(self, col, v) return { op = "eq",   col = col and col.__col, v = v } end,
    like = function(self, col, v) return { op = "like", col = col and col.__col, v = v } end,
    gt   = function(self, col, v) return { op = "gt",   col = col and col.__col, v = v } end,
    lt   = function(self, col, v) return { op = "lt",   col = col and col.__col, v = v } end,
    AND  = function(self, ...) return { op = "and", parts = { ... } } end,
    OR   = function(self, ...) return { op = "or",  parts = { ... } } end,
}
