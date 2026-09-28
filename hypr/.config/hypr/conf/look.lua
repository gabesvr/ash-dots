-- Visual leve, focado em desempenho
hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 6,
        -- Sem contorno nas janelas
        border_size = 0,

        resize_on_border = false,

        -- Permite tearing para janelas com a regra "immediate" (jogos)
        allow_tearing = true,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        -- Blur e sombra desligados: são os efeitos mais caros na GPU
        shadow = { enabled = false },
        blur   = { enabled = false },
    },

    render = {
        -- 2 = direct scanout só para jogos em fullscreen (pula o compositor)
        direct_scanout = 2,
    },

    misc = {
        -- 2 = VRR apenas em fullscreen (evita flicker no desktop)
        vrr = 2,
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },

    -- Sem animações: tudo instantâneo
    animations = {
        enabled = false,
    },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },
})
