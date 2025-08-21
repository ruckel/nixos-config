local mp = require 'mp'
local utils = require 'mp.utils'

local opts_path = mp.command_native({"expand-path", "~~/script-opts/osc.conf"})

local function read_visibility()
    local file = io.open(opts_path, "r")
    if not file then return nil end
    for line in file:lines() do
        local key, val = line:match("^(%s*visibility)%s*=%s*(%S+)")
        if key == "visibility" then
            file:close()
            return val
        end
    end
    file:close()
    return nil
end

local function write_visibility(mode)
    local lines = {}
    local found = false
    local file = io.open(opts_path, "r")
    if file then
        for line in file:lines() do
            if line:match("^%s*visibility%s*=") then
                table.insert(lines, "visibility=" .. mode)
                found = true
            else
                table.insert(lines, line)
            end
        end
        file:close()
    end
    if not found then
        table.insert(lines, "visibility=" .. mode)
    end
    file = io.open(opts_path, "w")
    if file then
        file:write(table.concat(lines, "\n") .. "\n")
        file:close()
    end
    mp.osd_message("OSC visibility set to: " .. mode)
end

local function toggle_visibility()
    local current = read_visibility()
    if current == "always" then
        write_visibility("auto")
    else
        write_visibility("always")
    end
end

mp.add_key_binding("i", "toggle-osc-visibility", toggle_visibility)
