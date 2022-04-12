-- TIME WIDGET

-- Requies
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

-- Function for seting up all parameters
-- Returns main time widget
local setup = function (refresh_interval, format, font, color)
    -- Default interval
    if refresh_interval == nil then
        refresh_interval = 1
    end

    -- Default format
    local date_command
    if format == nil then
        date_command = "date"
    else
        date_command = "date +\""..format.."\""
    end

    local time_widget = wibox.widget {
        widget = wibox.widget.textbox,
        font = font
    }

    -- Refresh timer
    gears.timer {
        timeout = refresh_interval,
        call_now = true,
        autostart = true,
        callback = function ()
            awful.spawn.easy_async_with_shell(date_command, function (out)
                if color == nil then
                    time_widget.text = out
                else
                    time_widget.markup = "<span foreground='"..color.."'>"..out.."</span>"
                end
            end)
        end
    }

    return time_widget
end

return setup