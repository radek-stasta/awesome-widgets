# awesome-widgets
Widgets for awesome window manager

## About
Recently, I decided to completely reinstall my computer and start from scratch with system that I personally create from the ground up. For that, I choose awesome window manager, since it gives me freedom to do practically anything I want. As my first project in this endeavour, I need to create some basic building blocks and so I created awesome-widgets project, where I put all widgets I will create for my system. And since I like to share my work, I would love if someone else can also use some of those if they like them or maybe give me some advice since I am pretty much awesomewm noob, having started with it just a couple weeks ago. Below you will find installation instructions to use my widgets in your systems and also some documentation for each widget sou you don't need to study source code.

## Installation
All you need to do is clone this repository preferably into your ~/.config/awesome folder so you have it in the same folder as your rc.lua. So in your ~/.config/awesome folder run command:
```
git clone https://github.com/radek-stasta/awesome-widgets.git
```
Then you just need to require those widgets in your rc.lua file and call setup function to get your widget. See documentation for each widget for more information how to use it

## Documentation
### button-sh-widget
Button widget for wibar menu calling sh command. Can be used as application launcher or to perform any sh script.

Usage:
```
-- require widget source
local button_setup_function = require("awesome-widgets.menu.button-sh-widget")
local button_sh_widget = button_setup_function(shape, icon, bg_color, fg_color, hover_color, outer_margin, inner_margin, sh_command)
```
Setup function parameters:
- shape: shape of button widget, module gears.shape (ex. gears.shape.circle)
- icon: path to icon displayed preferably from your theme file (ex. beautiful.wallpaper_icon)
- bg_color: background color (ex. beautiful.bg_normal)
- fg_color: foreground color of provided icon (ex beautiful.fg_normal)
- hover_color: background color if hovered over (ex beautiful.bg_focus)
- outer_margin: margin from top and bottom of wibox and left and right from other widgets
- inner_margin: margin of icon from widget borders (you can resize icon within button itself with this)
- sh_command: shell command to execute on click (ex. "feh --randomize --bg-fill ~/Pictures/*")
