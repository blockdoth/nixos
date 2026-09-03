hl.config({

    input = {
        kb_layout = "us",
        kb_options = "caps:ctrl_modifier",
        sensitivity = 0.2,
        touchpad = {
            natural_scroll = true,
        },
    },
    
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})