-- PERCENTAGE BAR

-- Requires
local wibox = require("wibox")

-- Meta class
PercentageBarWidget = {
    max_value = nil,
    actual_value = nil,
    width = nil,
    background_color = nil,
    color = nil,
    inside_widget = nil,
    vertical = nil,
    halign = nil,
}

function PercentageBarWidget:new(width, max_value, background_color, color, inside_widget, vertical, halign)
    local o = {}
    setmetatable(o, {__index = self})

    o.width = width
    o.max_value = max_value
    o.actual_value = 0
    o.background_color = background_color or nil
    o.color = color or nil
    o.inside_widget = inside_widget or nil
    o.vertical = vertical or false
    o.halign = halign or "center"

    -- create o.percentage_widget for other functions
    o.percenate_widget = wibox.widget {
        widget = wibox.widget.progressbar,
        max_value = o.max_value,
        value = o.actual_value,
        forced_width = o.width,
        background_color = o.background_color,
        color = o.color
    }

    -- if vertical is defined and true, create rotate widget above
    if (o.vertical == true) then
        o.widget = wibox.widget {
            layout = wibox.container.rotate,
            direction = "east",
            forced_width = o.width,
            o.percenate_widget
        }
    else
        o.widget = o.percenate_widget
    end

    -- if inside_widget is defined, create stack widget above o.percentage_widget
    if not (o.inside_widget == nil) then
        o.widget = wibox.widget {
            layout = wibox.layout.stack,
            o.widget,
            {
                widget = wibox.container.place,
                halign = o.halign,
                o.inside_widget
            }
        }
    else
        o.widget = o.widget
    end

    return o
end

function PercentageBarWidget:set_value(value)
    self.percenate_widget:set_value(value)
end

return PercentageBarWidget