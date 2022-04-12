-- BUTTON SH WIDGET

-- Requires
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Function for seting up all parameters
-- Returns main button widget
local setup = function (shape, icon, bg_color, fg_color, hover_color, outer_margin_factor, inner_margin_factor, click_shell_command)
    local background_widget = wibox.widget {
        -- Background
        widget = wibox.container.background,
        shape_clip = true,
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
                    {
                        -- Icon
                        widget = wibox.widget.imagebox,
                        resize = true,
                        image = gears.color.recolor_image(icon, fg_color)
                    }
                }
            }
        }
    }
    background_widget:connect_signal("mouse::enter", function (c) c:set_bg(hover_color) end)
    background_widget:connect_signal("mouse::leave", function (c) c:set_bg(bg_color) end)

    local button_widget = wibox.widget {
        -- Outer margin
        widget = wibox.container.margin,
        top = beautiful.menu_height * outer_margin_factor,
        bottom = beautiful.menu_height * outer_margin_factor,
        {
            layout = wibox.layout.align.horizontal,
            background_widget
        }
    }
    button_widget:connect_signal("button::press", function (c) awful.spawn.easy_async_with_shell(click_shell_command, function () end) end)

    return button_widget
end

return setup
