-- Input: foco em latência mínima
hl.config({
    input = {
        kb_layout  = "es",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        -- Teclado mais responsivo (padrão era 25/600)
        repeat_rate  = 50,
        repeat_delay = 250,

        follow_mouse = 1,

        -- Mouse 1:1, sem aceleração (raw input)
        sensitivity    = 0,
        accel_profile  = "flat",
        force_no_accel = false,

        touchpad = {
            natural_scroll = false,
        },
    },

    cursor = {
        -- 0 = sempre usar cursor de hardware (plano próprio da GPU, menos latência)
        no_hardware_cursors = 0,
    },
})

-- Touchpad mantém aceleração adaptativa (fica mais usável)
hl.device({
    name          = "asuf1204:00-2808:0202-touchpad",
    accel_profile = "adaptive",
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Teclado externo Akko/MonsGeek TAC75 HE: layout US
-- (o do notebook continua no layout global acima)
for _, name in ipairs({ "-------akko-keyboard", "-------akko-keyboard-1" }) do
    hl.device({ name = name, kb_layout = "us" })
end
