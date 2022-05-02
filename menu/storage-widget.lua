-- STORAGE WIDGET

-- Requires
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

-- Meta class
StorageWidget = {
    storage_use_percentage = nil,
    storage_use_absolute = nil,
    storage_free = nil,
    storage_total = nil,

    refresh_interval = nil,
    device = nil,
    format = nil,
    font = nil,
    color = nil,
    widget = nil
}

local get_storage_values = function(o)
    local command = "df -ha "..o.device

    awful.spawn.easy_async_with_shell(command, function(out)
        local device_line

        -- Split result by line and get only second line (with device data)
        for split in out:gmatch("[^\r\n]+") do
            if split:gmatch("/", 1, true) then
                device_line = split
            end
        end
        
        -- Split device line by values    
        local values = {}
        for value in device_line:gmatch("%S+") do
            -- Get only lines with actual values
            if not(string.match(value, "/")) then
                -- Save numeric values to table
                table.insert(values, tonumber(string.match(value, "%d+")))
            end
        end

        -- Save object values
        o.storage_total = values[1]
        o.storage_use_absolute = values[2]
        o.storage_free = values[3]
        o.storage_use_percentage = values[4]
    end)
end

-- Constructor
-- format: %t = storage_total, %f = storage_free, %a = storage_use_absolute, %p = storage_use_percentage
function StorageWidget:new(refresh_interval, device, format, font, color)
    local o = {}
    setmetatable(o, {__index = self})

    o.storage_total = 0
    o.storage_free = 0
    o.storage_use_absolute = 0
    o.storage_use_percentage = 0

    o.refresh_interval = refresh_interval
    o.device = device
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
            get_storage_values(o)

            local text = o.format
            if o.format == nil then
                text = o.storage_use_percentage
            else
                text = text:gsub("%%t", o.storage_total)
                text = text:gsub("%%f", o.storage_free)
                text = text:gsub("%%a", o.storage_use_absolute)
                text = text:gsub("%%p", o.storage_use_percentage)
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
function StorageWidget:get_storage_usage_percent()
    return self.storage_use_percentage
end

return StorageWidget