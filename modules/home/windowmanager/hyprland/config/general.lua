
hl.config({



    dwindle = {
        preserve_split = true,
    },

    ecosystem = {
        no_donation_nag = true,
        no_update_news = true,
    },

    cursor = {
        no_hardware_cursors = 0,
        no_warps = true,
    },

    debug = {
        disable_logs = false,
    },

    
    misc = {
        background_color = "rgb(282828)",
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_watchdog_warning = true,
        enable_anr_dialog = false,
        session_lock_xray = true,
    },

    
    general = {
        border_size = 1,
        col = {
            active_border = "rgb(83a598)",
            inactive_border = "rgb(665c54)",
        },
        gaps_in = 6,
        gaps_out = 6,
        layout = "dwindle",
    },


    -- group = {
    --     groupbar = {
    --         col = {
    --             active = "rgb(83a598)",
    --             inactive = "rgb(665c54)",
    --         },
    --         text_color = "rgb(d5c4a1)",
    --     },
    --     col = {
    --         border_active = "rgb(83a598)",
    --         border_inactive = "rgb(665c54)",
    --         border_locked_active = "rgb(8ec07c)",
    --     },
    -- },

    xwayland = {
        force_zero_scaling = true,
    },
})