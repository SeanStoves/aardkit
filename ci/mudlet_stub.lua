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
decho = note("decho")
dechoLink = note("dechoLink")
hecho = note("hecho")
startLogging = note("startLogging")
echo = note("echo")
decho = note("decho")
hecho = note("hecho")
cechoLink = note("cechoLink")
echoLink = note("echoLink")   -- the fallback path when dechoLink is missing
deleteLine = note("deleteLine")
selectCurrentLine = note("selectCurrentLine")
selectString = function() return 1 end
getFgColor = function() return 200, 180, 160 end
copy = note("copy")
appendBuffer = note("appendBuffer")
getCurrentLine = function() return "" end
getLineCount = function() return 0 end
moveCursor = note("moveCursor")
moveCursorEnd = note("moveCursorEnd")
send = note("send")
sendAll = note("sendAll")
enableTrigger = note("enableTrigger")
disableTrigger = note("disableTrigger")
killTrigger = note("killTrigger")
killTimer = note("killTimer")
tempTimer = function() return 1 end
tempLineTrigger = function() return 1 end
tempRegexTrigger = function() return 1 end
registerNamedTimer = note("registerNamedTimer")
deleteNamedTimer = note("deleteNamedTimer")
registerAnonymousEventHandler = function() return 1 end
killAnonymousEventHandler = note("killAnonymousEventHandler")
postHTTP = note("postHTTP")
getHTTP = note("getHTTP")

-- map api
addRoom = note("addRoom")
addAreaName = function() return 1 end
setRoomArea = note("setRoomArea")
setRoomCoordinates = note("setRoomCoordinates")
setRoomName = note("setRoomName")
setRoomEnv = note("setRoomEnv")
setRoomUserData = note("setRoomUserData")
setExit = note("setExit")
addSpecialExit = note("addSpecialExit")
setCustomEnvColor = note("setCustomEnvColor")
setLabelWheelCallback = note("setLabelWheelCallback")
raiseWindow = note("raiseWindow")
lowerWindow = note("lowerWindow")
setMapZoom = note("setMapZoom")
getMapZoom = function() return 3 end
roomExists = function() return true end
getRooms = function() return {} end
getPlayerRoom = function() return 1 end
getPath = function() return true end
doSpeedWalk = note("doSpeedWalk")
speedWalkDir = {}
deleteMap = note("deleteMap")
saveMap = function() return true end
centerview = note("centerview")

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

yajl = {
    to_string = function(v) return "{}" end,
    to_value = function(s) return {} end,
}

---
-- Geyser
---

local function widget(extra)
    local w = {}
    setmetatable(w, { __index = function() return function() return w end end })
    for k, v in pairs(extra or {}) do w[k] = v end
    return w
end

local function ctor(kind)
    return { new = function(_, cons, parent)
        local w = widget({ name = (cons and cons.name) or kind })
        w.text = widget({})
        return w
    end }
end

Geyser = {
    add = function() return true end,
    Gauge = ctor("Gauge"),
    Label = ctor("Label"),
    MiniConsole = ctor("MiniConsole"),
    UserWindow = ctor("UserWindow"),
    Container = ctor("Container"),
    -- Real Mudlet ships GeyserScrollBox.lua, so code may reach for it. It is
    -- still guarded at the call site, because older builds don't have it.
    ScrollBox = ctor("ScrollBox"),
}

Adjustable = {
    Container = {
        new = function(_, cons) return widget({ name = cons and cons.name or "ac" }) end,
        saveAll = note("saveAll"),
        loadAll = note("loadAll"),
    },
}

---
-- db: layer
---

local Sheet = {}
Sheet.__index = function(t, k)
    -- any column read gives back a marker the query builders can carry around
    return rawget(t, k) or { __col = k, __sheet = rawget(t, "__name") }
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
    set = function(self, field, value, query)
        if type(field) ~= "table" or not field.__col then
            error("db:set takes a column (sheet.column), not a sheet", 2)
        end
        return 0
    end,
    delete = function(self, sheet, where) return 0 end,
    -- carry the column and value, so fetch above can honour them
    eq   = function(self, col, v) return { op = "eq",   col = col and col.__col, v = v } end,
    like = function(self, col, v) return { op = "like", col = col and col.__col, v = v } end,
    gt   = function(self, col, v) return { op = "gt",   col = col and col.__col, v = v } end,
    lt   = function(self, col, v) return { op = "lt",   col = col and col.__col, v = v } end,
    AND  = function(self, ...) return { op = "and", parts = { ... } } end,
    OR   = function(self, ...) return { op = "or",  parts = { ... } } end,
}
