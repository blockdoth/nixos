hl.monitor({
    output = "DP-1",
    mode = "2560x1440@143.972Hz",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "DP-2",
    mode = "1920x1200@99.94Hz",
    position = "2560x-310",
    scale = 1,
    transform = 3,
})

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "DP-1",
    default = true,
})

hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-1" })
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })

hl.workspace_rule({
    workspace = "11",
    monitor = "DP-2",
    default = true,
})
hl.workspace_rule({ workspace = "12", monitor = "DP-2" })
hl.workspace_rule({ workspace = "13", monitor = "DP-2" })
hl.workspace_rule({ workspace = "14", monitor = "DP-2" })
hl.workspace_rule({ workspace = "15", monitor = "DP-2" })
hl.workspace_rule({ workspace = "16", monitor = "DP-2" })
hl.workspace_rule({ workspace = "17", monitor = "DP-2" })
