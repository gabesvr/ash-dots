-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Mouse igual ao VSCode: seleciona, arrasta, rola, botão direito abre menu
opt.mouse = "a"
opt.mousemodel = "popup_setpos"

-- Shift+setas seleciona; digitar com algo selecionado substitui (como no VSCode)
opt.keymodel = "startsel,stopsel"
opt.selectmode = "mouse,key"

opt.clipboard = "unnamedplus" -- área de transferência do sistema (wl-clipboard)
opt.whichwrap:append("<,>,[,]") -- setas passam para a linha de cima/baixo
opt.scrolloff = 8
opt.relativenumber = false -- números normais, como no VSCode
opt.wrap = false
opt.confirm = true -- pergunta se quer salvar em vez de dar erro
