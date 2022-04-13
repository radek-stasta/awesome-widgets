-- TIME WIDGET

-- Requies
local wibox = require("wibox")
local gears = require("gears")

-- Function for seting up all parameters
-- Returns main time widget
local setup = function (refresh_interval, format, font, color)
    -- Default interval
    if refresh_interval == nil then
        refresh_interval = 1
    end

    -- Default format
    if format == nil then
        format = "%m/%d/%Y %I:%M %p"
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
            if color == nil then
                time_widget.text = os.date(format)
            else
                time_widget.markup = "<span foreground='"..color.."'>"..os.date(format).."</span>"
            end
        end
    }

    return time_widget
end

return setup