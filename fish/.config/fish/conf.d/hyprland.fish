# Sessão: login no TTY1 → abre o Hyprland direto (sem SDDM, zero RAM de display manager)
if status is-login
    # Hyprland só na NVIDIA: não carrega o driver da AMD (Mesa/LLVM) → ~20-40 MB a menos.
    # Obs.: saídas de vídeo USB-C (ligadas na AMD) param de funcionar; HDMI continua.
    # Para usar monitor pela USB-C: comente a linha abaixo e reinicie a sessão.
    test -e /dev/dri/nvidia-card; and set -gx AQ_DRM_DEVICES /dev/dri/nvidia-card

    if test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
        exec start-hyprland
    end
end
