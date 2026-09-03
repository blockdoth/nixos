
local function bind(key, dispatcher, flags)
    hl.bind("SUPER + " .. key, dispatcher, flags)
end

local function exec(key, command, flags)
    bind(key, hl.dsp.exec_cmd(command), flags)
end

------------------------------------------------------------
-- Keybinds
------------------------------------------------------------

exec("A", "pypr toggle term")
exec("B", "zen-twilight")
exec("C", "hyprpicker -a")
exec("D", "pypr toggle signal")
exec("E", "pypr toggle obsidian")
exec("F", "thunar")
exec("G", "ghostty")

-- Preserve the original SUPER+H sequence exactly.
bind("H", function()
    hl.dispatch(hl.dsp.togglespecialworkspace("magic"))
    hl.dispatch(hl.dsp.movetoworkspace("+0"))
    hl.dispatch(hl.dsp.togglespecialworkspace("magic"))
    hl.dispatch(hl.dsp.movetoworkspace("special:magic"))
    hl.dispatch(hl.dsp.togglespecialworkspace("magic"))
end)

exec("L", "pidof hyprlock | hyprlock")
bind("SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"))

-- setprop active opaque toggle
bind("M", function()
    hl.exec_cmd("hyprctl setprop activewindow opaque toggle")
end)

bind("N", hl.dsp.window.fullscreen())
bind("O", hl.dsp.window.pseudo())
bind("P", hl.dsp.window.pin())
bind("Q", hl.dsp.window.close())
exec("R", "rofi -show drun -show-icons")
exec("SHIFT + R", "zen -new-tab 'https://www.youtube.com/watch?v=dQw4w9WgXWcQ'")
exec("S", "pypr toggle spotify")
exec("T", "alacritty")
bind("V", hl.dsp.window.float({ action = "toggle" }))
exec("W", "pypr toggle whatsapp")
exec("SHIFT + W", "wlogout-script")
exec("Y", "zeditor ~/nixos")
exec("Z", "pypr zoom")
exec("SHIFT + Z", "pypr zoom ++0.6")
exec("SHIFT + S", "grimblast --notify --freeze copysave area")

------------------------------------------------------------
-- Focus / move
------------------------------------------------------------

for key, direction in pairs({
    left = "l",
    down = "r",
    up = "u",
    right = "d",
}) do
    bind(key, hl.dsp.focus({ direction = direction }))
end

for key, direction in pairs({
    left = "l",
    right = "r",
    up = "u",
    down = "d",
}) do
    bind("SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- The original config contains a second set of SUPER+arrow binds
-- that is functionally equivalent to the first focus set.

------------------------------------------------------------
-- Workspaces
------------------------------------------------------------

for i = 1, 7 do
    bind(tostring(i), hl.dsp.focus({ workspace = tostring(i) }))
    bind("SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i), silent = true }))
end

for i = 1, 7 do
    local workspace = tostring(i + 10)
    bind("CTRL + " .. i, hl.dsp.focus({ workspace = workspace }))
    bind("SHIFT + CTRL + " .. i,
        hl.dsp.window.move({ workspace = workspace, silent = true }))
end

bind("Tab", hl.dsp.focus({ workspace = "previous" }))

------------------------------------------------------------
-- Media / brightness
------------------------------------------------------------

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set +20"),
    { repeating = true })

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 20-"),
    { repeating = true })

hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl -a play-pause"))
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl -a stop"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl -a previous"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl -a next"))

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    { repeating = true })

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    { repeating = true })

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))

hl.bind("XF86Calculator",
    hl.dsp.exec_cmd("zen -new-tab https://www.desmos.com/calculator"))

hl.bind("Print",
    hl.dsp.exec_cmd("grimblast --notify copysave screen"))

------------------------------------------------------------
-- Mouse binds
------------------------------------------------------------

hl.bind("SUPER + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true })

hl.bind("SUPER + SHIFT + mouse:272",
    hl.dsp.window.resize(),
    { mouse = true })

hl.bind("SUPER + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true })

hl.bind("SUPER + CTRL + mouse:272",
    hl.dsp.window.float({ action = "toggle" }),
    { mouse = true })
