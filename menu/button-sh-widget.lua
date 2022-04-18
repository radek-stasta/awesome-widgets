-- BUTTON SH WIDGET

-- Requires
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Meta class
ButtonShWidget = {
    shape = nil,
    icon = nil,
    bg_color = nil,
    fg_color = nil,
    hover_color = nil,
    outer_margin_factor = nil,
    inner_margin_factor = nil,
    click_shell_command = nil,
    widget = nil
}

function ButtonShWidget:new(shape, icon, bg_color, fg_color, hover_color, outer_margin_factor, inner_margin_factor, click_shell_command)
    local o = {}
    setmetatable(o, {__index = self})

    o.shape = shape
    o.icon = icon
    o.bg_color = bg_color
    o.fg_color = fg_color
    o.hover_color = hover_color
    o.outer_margin_factor = outer_margin_factor
    o.inner_margin_factor = inner_margin_factor
    o.click_shell_command = click_shell_command

    local background_widget = wibox.widget {
        -- Background
        widget = wibox.container.background,
        shape_clip = true,
        bg = o.bg_color,
        shape = o.shape,
        {
            layout = wibox.layout.align.horizontal,
            {
                -- Inner margin
                widget = wibox.container.margin,
                margins = beautiful.menu_height * o.inner_margin_factor,
                {
                    layout = wibox.layout.align.horizontal,
                    {
                        -- Icon
                        widget = wibox.widget.imagebox,
                        resize = true,
                        image = gears.color.recolor_image(o.icon, o.fg_color)
                    }
                }
            }
        }
    }
    background_widget:connect_signal("mouse::enter", function (c) c:set_bg(o.hover_color) end)
    background_widget:connect_signal("mouse::leave", function (c) c:set_bg(o.bg_color) end)

    o.widget = wibox.widget {
        -- Outer margin
        widget = wibox.container.margin,
        top = beautiful.menu_height * o.outer_margin_factor,
        bottom = beautiful.menu_height * o.outer_margin_factor,
        {
            layout = wibox.layout.align.horizontal,
            background_widget
        }
    }
    o.widget:connect_signal("button::press", function (c) awful.spawn.easy_async_with_shell(o.click_shell_command, function () end) end)

    return o
end

return ButtonShWidget
