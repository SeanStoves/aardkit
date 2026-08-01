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
unpack = unpack or table.unpack

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
  mkdir = function() return true end,
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

local store = {}
function table.save(path, tbl) store[path] = tbl end
function table.load(path, tbl)
    local src = store[path]
    if not src then return false end
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
    fetch = function(self, sheet, where) return db.__data[sheet] or {} end,

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
    eq = function(self, col, v) return { op = "eq" } end,
    like = function(self, col, v) return { op = "like" } end,
    gt = function(self, col, v) return { op = "gt" } end,
    lt = function(self, col, v) return { op = "lt" } end,
    AND = function(self, ...) return { op = "and" } end,
    OR = function(self, ...) return { op = "or" } end,
}
