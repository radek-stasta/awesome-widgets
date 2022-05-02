-- MEMORY WIDGET

-- Requires
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")

-- Meta class
MemoryWidget = {
    memory_use_percentage = nil,
    memory_use_absolute = nil,
    memory_total = nil,

    refresh_interval = nil,
    format = nil,
    font = nil,
    color = nil,
    widget = nil
}

local calculate_memory_values = function(o, proc_lines)
    local values = {}

    -- Extract label and value from each proc line and save it to values table
    for key, value in ipairs(proc_lines) do
        local label_value_split = {}
        
        -- Split on : character
        for str in string.gmatch(value, "([^:]+)") do
            table.insert(label_value_split, str)
        end
        
        -- Get only number from second part of split
        label_value_split[2] = string.match(label_value_split[2], "%d[%d]*")
        
        --- Save results as key = label, value = value
        values[label_value_split[1]] = label_value_split[2]
    end

    -- Save total memory
    o.memory_total = math.floor((values["MemTotal"] / 1000000) * 10 + 0.5) / 10

    -- Compute absolute memory use
    o.memory_use_absolute = math.floor(((values["MemTotal"] - values["MemFree"] - values["Buffers"] - values["Cached"]) / 1000000) * 10 + 0.5) /10

    -- Compute memory percentage use
    o.memory_use_percentage = math.floor((((values["MemTotal"] - values["MemFree"] - values["Buffers"] - values["Cached"]) / values["MemTotal"]) * 100) + 0.5)
end


local read_proc_meminfo = function ()
    local proc_lines = {}
    for line in io.lines("/proc/meminfo") do
        table.insert(proc_lines, line)
    end

    return proc_lines
end

-- Constructor
-- format: %t = memory_total, %a = memory_use_absolute, %p = memory_use_percentage
function MemoryWidget:new(refresh_interval, format, font, color)
    local o = {}
    setmetatable(o, {__index = self})

    o.memory_use_percentage = 0

    o.refresh_interval = refresh_interval
    o.format = format or nil
    o.font = font or nil
    o.color = color or nil

    o.widget = wibox.widget {
        widget = wibox.widget.textbox,
        font = font
    }

    -- Refresh timer
    gears.timer {
        timeout = o.refresh_interval,
        call_now = true,
        autostart = true,
        callback = function ()
            calculate_memory_values(o, read_proc_meminfo())

            local text = o.format
            if o.format == nil then
                text = o.memory_use_percentage
            else
                text = text:gsub("%%t", o.memory_total)
                text = text:gsub("%%a", o.memory_use_absolute)
                text = text:gsub("%%p", o.memory_use_percentage)
            end

            if o.color == nil then
                o.widget.text = text
            else
                o.widget.markup = "<span foreground='"..o.color.."'>"..text.."</span>"
            end
        end
    }

    return o
end

-- Function returning numeric cpu percentage use
function MemoryWidget:get_memory_usage_percent()
    return self.memory_use_percentage
end

return MemoryWidget