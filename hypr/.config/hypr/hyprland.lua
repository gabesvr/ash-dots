-- Hyprland — config focada em desempenho e gaming
-- Laptop: Ryzen 7 7445HS + RTX 4050 (tela ligada na NVIDIA)
-- Módulos em ~/.config/hypr/conf/

local dir = os.getenv("HOME") .. "/.config/hypr/conf/"
for _, m in ipairs({ "env", "monitors", "input", "look", "rules", "binds", "autostart" }) do
    dofile(dir .. m .. ".lua")
end

-- USOLINUX: sempre flutuante e centralizado
hl.window_rule({
    name   = "usolinux-float",
    match  = { title = "^(USOLINUX)$" },
    float  = true,
    center = true,
    size   = "820 540",
})

-- ACCELA: sempre flutuante e centralizado (Custom Theme by gabesvr)
hl.window_rule({
    name   = "accela-float",
    match  = { class = "^([aA][cC][cC][eE][lL][aA]|god\\.is\\.in\\.the\\.wired\\.accela)$" },
    float  = true,
    center = true,
    size   = "820 540",
})
hl.window_rule({
    name   = "accela-float-title",
    match  = { title = "^(ACCELA)$" },
    float  = true,
    center = true,
    size   = "820 540",
})
