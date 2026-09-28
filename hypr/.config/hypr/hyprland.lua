-- Hyprland — config focada em desempenho e gaming
-- Laptop: Ryzen 7 7445HS + RTX 4050 (tela ligada na NVIDIA)
-- Módulos em ~/.config/hypr/conf/

local dir = os.getenv("HOME") .. "/.config/hypr/conf/"
for _, m in ipairs({ "env", "monitors", "input", "look", "rules", "binds", "autostart" }) do
    dofile(dir .. m .. ".lua")
end
