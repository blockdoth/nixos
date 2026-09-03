hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:ctrl_modifier",
        sensitivity = 0.2,
        touchpad = {
            natural_scroll = true,
        },
    },
    cursor = {
        no_hardware_cursors = 0,
        no_warps = true,
    },    
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})