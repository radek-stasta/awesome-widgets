-- FRAME WIDGET

-- Requires
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Meta class
FrameWidget = {
    shape = nil,
    bg_color = nil,
    outer_margin_factor = nil,
    inner_margin_factor = nil,
    inside_widget = nil,
    halign = nil,
    forced_width = nil,
    widget = nil
}

function FrameWidget:new(shape, bg_color, outer_margin_factor, inner_margin_factor, inside_widget, halign, forced_width)
    local o = {}
    setmetatable(o, {__index = self})

    o.shape = shape
    o.bg_color = bg_color
    o.outer_margin_factor = outer_margin_factor
    o.inner_margin_factor = inner_margin_factor
    o.inside_widget = inside_widget
    o.halign = halign or "center"
    o.forced_width = forced_width or nil

    o.widget = wibox.widget {
        -- Outer margin
        widget = wibox.container.margin,
        top = beautiful.menu_height * o.outer_margin_factor,
        bottom = beautiful.menu_height * o.outer_margin_factor,
        {
            layout = wibox.layout.align.horizontal,
            {
                -- Background
                widget = wibox.container.background,
                bg = o.bg_color,
                shape = o.shape,
                shape_clip = true,
                {
                    layout = wibox.layout.align.horizontal,
                    {
                        -- Inner margin
                        widget = wibox.container.margin,
                        margins = beautiful.menu_height * o.inner_margin_factor,
                        forced_width = o.forced_width,
                        {
                            -- Align
                            widget = wibox.container.place,
                            halign = o.halign,
                            o.inside_widget
                        }
                    }
                }
            }
        }
    }

    return o
end

return FrameWidget