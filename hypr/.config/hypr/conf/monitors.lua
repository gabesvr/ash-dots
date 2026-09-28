-- Monitores
-- Tudo ligado direto na NVIDIA (card1): painel eDP-1 e a porta HDMI. Sem cópia entre GPUs.
--
-- Com monitor externo conectado, a tela do notebook é desligada sozinha:
-- a GPU só desenha uma tela e jogos/compositor ficam todos no externo.
-- Desconectou → o painel volta. A barra é reposicionada pelo script `bar`.

local laptop = { output = "eDP-1", mode = "1920x1200@144", position = "0x0", scale = 1.25 }

-- Monitor externo atual: AOC 24G4 (HDMI) — 1080p @ 180 Hz, sem escala
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@180", position = "0x0", scale = 1 })

-- Qualquer outro monitor: maior taxa de atualização disponível
hl.monitor({ output = "", mode = "highrr", position = "auto", scale = "auto" })

local function has_external()
    for _, m in ipairs(hl.get_monitors()) do
        -- só saídas físicas contam (ignora o FALLBACK/HEADLESS que o Hyprland cria sem telas)
        if m.name:match("^HDMI") or m.name:match("^DP") then return true end
    end
    return false
end

local function apply_laptop()
    laptop.disabled = has_external()
    hl.monitor(laptop)
end

apply_laptop()

local function on_hotplug()
    -- o `bar` confere o estado do painel (e recarrega se preciso) e reposiciona a barra
    hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/bar")
end
hl.on("monitor.added", on_hotplug)
hl.on("monitor.removed", on_hotplug)

-- XWayland (jogos via Proton/Wine, Steam) renderiza na resolução nativa,
-- sem upscale borrado da escala 1.25 → jogos em fullscreen ficam na resolução real.
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
