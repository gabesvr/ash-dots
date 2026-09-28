-- Autostart: só roda uma vez, no início da sessão (não em reload)
hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/bar")   -- yambar no monitor certo
    hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/wallpaper")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/notif reset")   -- não perturbe começa desligado
end)
