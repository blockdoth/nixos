
hl.layer_rule({
    match = { namespace = "logout_dialog" },
    blur = true,
})


local function class_rule(class, effect)
    local rule = {
        match = { class = class },
    }
    for k, v in pairs(effect) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

class_rule("^(firefox|zen-twilight)$", { opacity = "0.85" })

hl.window_rule({
    match = { title = "^(.*YouTube.*)$" },
    opacity = "1.00",
})

class_rule("^(spotify|Spotify)$", { opacity = "0.75" })
class_rule("^(VSCodium|codium)$", { opacity = "0.85" })
class_rule("^(dev.zed.Zed)$", { opacity = "0.9" })
class_rule("^(vesktop)$", { opacity = "0.85" })
class_rule("^(jetbrains)$", { opacity = "0.85" })
class_rule("^(org.gnome.Nautilus)$", { opacity = "0.80" })
class_rule("^(thunar)$", { opacity = "0.80" })
class_rule("^(com.rtosta.zapzap)$", { opacity = "0.9" })
class_rule("^(Signal|signal)$", { opacity = "0.7" })
class_rule("^(anki)$", { opacity = "0.9" })
class_rule("^(obsidian)$", { opacity = "0.9" })

local pip = {
    match = { title = "^(Picture-in-Picture)" },
}
hl.window_rule({ match = pip.match, float = true })
hl.window_rule({ match = pip.match, pin = true })
hl.window_rule({ match = pip.match, size = { 800, 450 } })
hl.window_rule({ match = pip.match, opacity = "1.0 override" })

local popup = {
    match = {
        class = "^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|Matplotlib)$",
    },
}
hl.window_rule({ match = popup.match, float = true })
hl.window_rule({ match = popup.match, pin = true })
hl.window_rule({
    match = popup.match,
    size = { "monitor_w * 0.4", "monitor_h * 0.4" },
})

local scratchpad = {
    match = {
        class = "^(scratchpad.alacritty|spotify|Spotify|com.rtosta.zapzap|Signal|signal|obsidian)$",
    },
}
hl.window_rule({ match = scratchpad.match, float = true })
hl.window_rule({ match = scratchpad.match, workspace = "special silent" })
hl.window_rule({ match = scratchpad.match, center = true })
hl.window_rule({ match = scratchpad.match, opacity = "0.8" })

class_rule("Beyond-All-Reason", { float = true, center = true })
class_rule("satty", { float = true, center = true })
class_rule("spring", { fullscreen = true })

hl.window_rule({
    match = { class = "vesktop" },
    workspace = "1",
})
hl.window_rule({
    match = { class = "^(firefox|zen-twilight)$" },
    workspace = "2",
})


-- hl.window_rule({
--     match = { class = "^()$", title = "^()$" },
--     blur = false,
-- })

hl.window_rule({
    match = { class = "vesktop" },
    no_initial_focus = true,
})


