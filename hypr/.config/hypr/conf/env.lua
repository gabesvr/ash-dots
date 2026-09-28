-- Variáveis de ambiente
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA (a tela está ligada na RTX 4050)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
-- Sem VSync forçado pelo driver: quem decide é o jogo / compositor
hl.env("__GL_SYNC_TO_VBLANK", "0")
-- Cache de shaders maior = menos stutter em jogos
hl.env("__GL_SHADER_DISK_CACHE_SIZE", "12000000000")
-- OpenGL (Minecraft etc.): no máximo 1 frame na fila → menos input lag
hl.env("__GL_MaxFramesAllowed", "1")
-- NVIDIA Reflex / DLSS nos jogos via Proton (DXVK-NVAPI)
hl.env("PROTON_ENABLE_NVAPI", "1")
hl.env("DXVK_ENABLE_NVAPI", "1")

-- Apps nativos Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Steam roda em XWayland com zero scaling: aumenta só a interface dele
hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "1.25")
