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
openUrl = note("openUrl")
echo = note("echo")
decho = note("decho")
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
appendBuffer = note("appendBuffer")
createBuffer = note("createBuffer")
clearWindow = note("clearWindow")
-- a console's own answer for how many lines fit; the pager reads it every repaint
getRowCount = function() return 24 end
getColumnCount = function() return 80 end
getCurrentLine = function() return "" end
getLineCount = function() return 0 end
moveCursor = note("moveCursor")
moveCursorEnd = note("moveCursorEnd")
scrollTo = note("scrollTo")
scrollUp = note("scrollUp")
getScroll = function() return 0 end
getLastLineNumber = function() return 0 end
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

getHTTP = function(url, headers)
    if http_reply.fail then raiseEvent("sysGetHttpError", http_reply.body, url)
    else raiseEvent("sysGetHttpDone", url, http_reply.body) end
    return true
end

-- map api
getAreaTableSwap = function() return { Midgaard = 1 } end
getAreaRooms = function() return { 1234 } end
searchRoom = function() return {} end
searchRoomUserData = function() return {} end
getExitStubs = function() return {} end
getSpecialExits = function() return {} end
removeSpecialExit = function() return nil end
clearSpecialExits = function() return nil end
deleteRoom = function() return nil end
deleteArea = function() return nil end
getDoors = function() return {} end
setDoor = function() return nil end
getRoomExits = function() return {} end
getRoomName = function() return "Somewhere" end
getTime = function() return "20260802-1300" end
clearRoomUserData = function() return nil end
getRoomUserData = function() return "" end
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
