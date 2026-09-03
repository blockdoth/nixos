local colors = {
    active = "rgb(83a598)",
    inactive = "rgb(665c54)",
    shadow = "rgba(28282899)",
}

hl.config({
    decoration = {
        rounding = 5,
        blur = {
            enabled = true,
            brightness = 1,
            contrast = 1.3,
            ignore_opacity = true,
            new_optimizations = true,
            noise = 0.0117,
            passes = 3,
            popups = true,
            size = 3,
            xray = false,
        },
        shadow = {
            color = colors.shadow,
            enabled = true,
            offset = { 5, 5 },
            range = 8,
            render_power = 2,
        },
    },

    group = {
        groupbar = {
            col = {
                active = colors.active,
                inactive = colors.inactive,
            },
        },
        col = {
            border_active = colors.active,
            border_inactive = colors.inactive,
        },
    },

    general = {
        border_size = 1,
        col = {
            active_border = colors.active,
            inactive_border = colors.inactive,
            nogroup_border = colors.inactive,
            nogroup_border_active = colors.active,
        },
        gaps_in = 6,
        gaps_out = 6,
        layout = "dwindle",
    },

    dwindle = {
        preserve_split = true,
    },
})