-- BUTTON SH WIDGET

-- Requires
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Widget for icon display
local icon_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    resize = true
}

-- Widget for setting inner margin of icon
local inner_margin_widget = wibox.widget {
    widget = wibox.container.margin,
    {
        layout = wibox.layout.align.horizontal,
        icon_widget
    }
}

-- Widget for background color and shape
local background_widget = wibox.widget {
    widget = wibox.container.background,
    shape_clip = true,
    {
        layout = wibox.layout.align.horizontal,
        inner_margin_widget
    }
}

-- Main button widget
local button_widget = wibox.widget {
    widget = wibox.container.margin,
    {
        layout = wibox.layout.align.horizontal,
        background_widget
    }
}

-- Function for seting up all parameters
-- Returns main button widget
local setup = function (shape, icon, bg_color, fg_color, hover_color, outer_margin_factor, inner_margin_factor, click_shell_command)
    -- Icon widget setup
    icon_widget.image = gears.color.recolor_image(icon, fg_color)

    -- Inner margin widget setup
    inner_margin_widget.margins = beautiful.menu_height * inner_margin_factor

    -- Background widget setup
    background_widget.bg = bg_color
    background_widget.shape = shape
    background_widget:connect_signal("mouse::enter", function (c) c:set_bg(hover_color) end)
    background_widget:connect_signal("mouse::leave", function (c) c:set_bg(bg_color) end)

    -- Main button widget setup
    button_widget.margins = beautiful.menu_height * outer_margin_factor
    button_widget:connect_signal("button::press", function (c) awful.spawn.easy_async_with_shell(click_shell_command, function () end) end)

    return button_widget
end

return setup
