-- Atalhos — só o essencial, sem duplicados
local HOME    = os.getenv("HOME")
local bin     = HOME .. "/.local/bin/"
local mainMod = "SUPER"

local function bind(keys, action, opts) hl.bind(mainMod .. " + " .. keys, action, opts) end
local function run(cmd) return hl.dsp.exec_cmd(cmd) end

-- ── Apps ────────────────────────────────────────────────────
bind("Return",     run("foot"))                             -- terminal
bind("T",          run("foot --app-id=foot-float"))         -- terminal flutuante
bind("Space",      run("fuzzel"))                           -- launcher
bind("W",          run("zen-browser"))                      -- navegador
bind("E",          run("thunar"))                           -- arquivos
bind("SHIFT + V",  run("foot --app-id=cava cava"))          -- visualizador de áudio

-- ── Janelas ─────────────────────────────────────────────────
bind("Q",          hl.dsp.window.close())
bind("F",          hl.dsp.window.float({ action = "toggle" }))
bind("SHIFT + F",  hl.dsp.window.fullscreen())

-- Mover / redimensionar com o mouse
bind("mouse:272",  hl.dsp.window.drag(),   { mouse = true })  -- SUPER + botão esquerdo = mover
bind("mouse:273",  hl.dsp.window.resize(), { mouse = true })  -- SUPER + botão direito  = redimensionar
bind("Z",          hl.dsp.window.drag(),   { mouse = true })  -- SUPER+Z segurado + mouse = mover
bind("X",          hl.dsp.window.resize(), { mouse = true })  -- SUPER+X segurado + mouse = redimensionar

-- Foco (SUPER+HJKL) e mover janela tiled (SUPER+SHIFT+HJKL)
for key, dir in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
    bind(key,              hl.dsp.focus({ direction = dir }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- ── Workspaces 1–10 ─────────────────────────────────────────
-- SUPER+N → ir · SUPER+SHIFT+N → levar a janela sob o cursor e seguir junto

-- Janela sob o cursor (floats têm prioridade)
local function window_under_cursor()
    local pos = hl.get_cursor_pos()
    local ws  = hl.get_active_workspace()
    local hit = nil
    for _, w in ipairs(hl.get_windows()) do
        if ws and w.workspace and w.workspace.id == ws.id
           and pos.x >= w.at.x and pos.x <= w.at.x + w.size.x
           and pos.y >= w.at.y and pos.y <= w.at.y + w.size.y then
            if w.floating then return w end
            hit = w
        end
    end
    return hit or hl.get_active_window()
end

local function send_to_workspace(ws)
    local target = window_under_cursor()
    if target then hl.dispatch(hl.dsp.focus({ window = target })) end
    hl.dispatch(hl.dsp.window.move({ workspace = ws }))
    hl.dispatch(hl.dsp.focus({ workspace = ws }))
end

for i = 1, 10 do
    local key = i % 10
    bind(key,               hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. key, function() send_to_workspace(i) end)
end

-- ── Utilitários ─────────────────────────────────────────────
bind("SHIFT + S",  run(bin .. "screenshot region"))         -- print de área (salva + copia)
hl.bind("Print",   run(bin .. "screenshot full"))           -- print da tela
bind("SHIFT + W",  run(bin .. "wallpaper pick"))            -- escolher wallpaper
bind("ALT + W",    run(bin .. "wallpaper next"))            -- próximo wallpaper
bind("C",          run(bin .. "control-center"))           -- central de controle
bind("N",          run(bin .. "notif clear"))              -- fechar notificações
bind("SHIFT + R",  run("hyprctl reload"))
bind("SHIFT + M",  run("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- ── Teclas de mídia / brilho (funcionam com a tela bloqueada) ─
local media = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  run("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume",  run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      media)
hl.bind("XF86AudioMute",         run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      run("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   run("brightnessctl -e4 -n2 set 5%+"),                  media)
hl.bind("XF86MonBrightnessDown", run("brightnessctl -e4 -n2 set 5%-"),                  media)
hl.bind("XF86AudioPlay",         run("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioPause",        run("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioNext",         run("playerctl next"),                                 { locked = true })
hl.bind("XF86AudioPrev",         run("playerctl previous"),                             { locked = true })
