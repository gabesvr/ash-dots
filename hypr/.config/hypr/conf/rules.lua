-- Regras de janela

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Corrige drag em apps XWayland
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

---- GAMING ----
-- Jogos Steam/Proton, gamescope e alguns nativos:
-- tearing (immediate) = menor input lag possível, sem animação/efeitos.
local games = "^(steam_app_.*|cs2|gamescope|osu!|Minecraft.*|.*\\.exe)$"

hl.window_rule({
    name        = "games-immediate",
    match       = { class = games },
    immediate   = true,
    no_anim     = true,
    no_blur     = true,
    no_shadow   = true,
    idle_inhibit = "always",
})

-- Minecraft Java nativo no Wayland: a classe muda entre versões/launchers,
-- o título ("Minecraft* 26.2 - ...") não. Mesmo tratamento dos jogos acima.
hl.window_rule({
    name        = "minecraft-immediate",
    match       = { title = "^Minecraft.*" },
    immediate   = true,
    no_anim     = true,
    no_blur     = true,
    no_shadow   = true,
    idle_inhibit = "always",
})

-- Terminal flutuante (SUPER+T)
hl.window_rule({
    name  = "foot-float",
    match = { class = "^foot-float$" },
    float = true,
    size  = "900 560",
})

-- Visualizador de áudio flutuante
hl.window_rule({
    name  = "cava-float",
    match = { class = "^cava$" },
    float = true,
    size  = "700 380",
})

-- Thunar sempre flutuante (abre centralizado).
-- Sem "size" aqui: forçar tamanho estica o 1º frame (fonte gigante por um instante).
-- O tamanho vem do próprio Thunar (xfconf last-window-width/height).
hl.window_rule({
    name  = "thunar-float",
    match = { class = "^([Tt]hunar)$" },
    float = true,
})
