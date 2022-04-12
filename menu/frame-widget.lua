-- FRAME WIDGET

-- Requires
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Function for seting up all parameters
-- Returns main frame widget
local setup = function (shape, bg_color, outer_margin_factor, inner_margin_factor, widget)
    local frame_widget = wibox.widget {
        -- Outer margin
        widget = wibox.container.margin,
        top = beautiful.menu_height * outer_margin_factor,
        bottom = beautiful.menu_height * outer_margin_factor,
        {
            layout = wibox.layout.align.horizontal,
            {
                -- Background
                widget = wibox.container.background,
                bg = bg_color,
                shape = shape,
                {
                    layout = wibox.layout.align.horizontal,
                    {
                        -- Inner margin
                        widget = wibox.container.margin,
                        margins = beautiful.menu_height * inner_margin_factor,
                        {
                            layout = wibox.layout.align.horizontal,
                            widget
                        }
                    }
                }
            }
        }
    }

    return frame_widget
end

return setup