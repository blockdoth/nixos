
hl.curve("overshot", {
    type = "bezier",
    points = {
        { 0.05, 0.9 },
        { 0.1, 1.05 },
    },
})

hl.animation({ leaf = "windows",      enabled = true, speed = 5,  bezier = "overshot" })
hl.animation({ leaf = "windowsOut",   enabled = true, speed = 7,  bezier = "overshot" })
hl.animation({ leaf = "windowsMove",  enabled = true, speed = 6,  bezier = "overshot" })
hl.animation({ leaf = "workspaces",   enabled = true, speed = 4,  bezier = "default" })
hl.animation({ leaf = "fade",         enabled = true, speed = 6,  bezier = "default" })
hl.animation({ leaf = "border",       enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle",  enabled = true, speed = 8,  bezier = "default" })
