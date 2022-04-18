-- TIME WIDGET

-- Requies
local wibox = require("wibox")
local gears = require("gears")

-- Meta class
TimeWidget = {
    refresh_interval = nil,
    format = nil,
    font = nil,
    color = nil,
    widget = nil
}

function TimeWidget:new(refresh_interval, format, font, color)
    local o = {}
    setmetatable(o, {__index = self})

    o.refresh_interval = refresh_interval or 1
    o.format = format or "%m/%d/%Y %I:%M %p"
    o.font = font or nil
    o.color = color or nil

    o.widget = wibox.widget {
        widget = wibox.widget.textbox,
        font = o.font
    }

    gears.timer {
        timeout = o.refresh_interval,
        call_now = true,
        autostart = true,
        callback = function ()
            if o.color == nil then
                o.widget.text = os.date(o.format)
            else
                o.widget.markup = "<span foreground='"..o.color.."'>"..os.date(o.format).."</span>"
            end
        end
    }

    return o
end

return TimeWidget