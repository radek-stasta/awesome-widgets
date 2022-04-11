-- FRAME WIDGET

-- Requires
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Widget containing widget from setup function
local layout_widget = wibox.widget {
    layout = wibox.layout.align.horizontal
}

-- Widget for setting inner margin of contained widget
local inner_margin_widget = wibox.widget {
    widget = wibox.container.margin,
    layout_widget
}

-- Widget for background color and shape
local background_widget = wibox.widget {
    widget = wibox.container.background,
    {
        layout = wibox.layout.align.horizontal,
        inner_margin_widget
    }
}

-- Main frame widget
local frame_widget = wibox.widget {
    widget = wibox.container.margin,
    {
        layout = wibox.layout.align.horizontal,
        background_widget
    }
}

-- Function for seting up all parameters
-- Returns main frame widget
local setup = function (shape, bg_color, outer_margin_factor, inner_margin_factor, widget)
    -- Layout widget setup
    layout_widget:setup {
        widget = widget
    }

    -- Inner margin widget setup
    inner_margin_widget.margins = beautiful.menu_height * inner_margin_factor

    -- Background widget setup
    background_widget.bg = bg_color
    background_widget.shape = shape

     -- Main button widget setup
     frame_widget.margins = beautiful.menu_height * outer_margin_factor

    return frame_widget
end

return setup