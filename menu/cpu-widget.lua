-- CPU WIDGET

-- Requires
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")

-- Meta class
CpuWidget = {
    cpu_last_sum = nil,
    cpu_last = nil,
    cpu_usage = nil,
    
    format = nil,
    font = nil,
    color = nil,
    widget = nil
}

local get_total_cpu_usage_percent = function(o, proc_lines)
    -- Get only first line
    local cpu_string = proc_lines[1]

    -- Split cpu string into array
    local cpu_now = {}
    for match in cpu_string:gmatch("(.-)".." ") do
        if not(tonumber(match) == nil) then
            table.insert(cpu_now, match)
        end
    end

    -- Sum all values
    local cpu_sum = 0
    for key, value in ipairs(cpu_now) do
        cpu_sum = cpu_sum + tonumber(value)
    end

    -- Get cpu delta
    local cpu_delta = cpu_sum - o.cpu_last_sum

    -- Get idle delta
    local cpu_idle_delta = tonumber(cpu_now[4]) - tonumber(o.cpu_last[4])

    -- Calculate time spent working
    local cpu_used = cpu_delta - cpu_idle_delta

    -- Get percentage
    local cpu_usage = math.floor((100 * cpu_used / cpu_delta) + 0.5)

    -- Save results as last values
    o.cpu_last = cpu_now
    o.cpu_last_sum = cpu_sum

    return cpu_usage;
end

local read_proc_stat = function ()
    local proc_lines = {}
    for line in io.lines("/proc/stat") do
        if string.find(line, "cpu") then
            table.insert(proc_lines, line)
        end
    end

    return proc_lines
end

-- Constructor
function CpuWidget:new(format, font, color)
    local o = {}
    setmetatable(o, {__index = self})

    o.cpu_last_sum = 0
    o.cpu_last = {}
    o.cpu_last[4] = 0
    o.cpu_usage_percent = 0
    o.format = format or nil
    o.font = font or nil
    o.color = color or nil

    o.widget = wibox.widget {
        widget = wibox.widget.textbox,
        font = o.font
    }

    -- Refresh timer
    gears.timer {
        timeout = 1,
        call_now = true,
        autostart = true,
        callback = function ()
            o.cpu_usage_percent = get_total_cpu_usage_percent(o, read_proc_stat())

            local text
            if o.format == nil then
                text = o.cpu_usage_percent
            else
                text = string.format(o.format, o.cpu_usage_percent)
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
function CpuWidget:get_cpu_usage_percent()
    return self.cpu_usage_percent
end

return CpuWidget