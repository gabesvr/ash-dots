-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Atalhos no estilo VSCode. Funcionam em qualquer modo; os comandos do Vim
-- continuam lá para quando quiser aprender. Lista completa: Ctrl+K Ctrl+S.

local map = vim.keymap.set

-- Seleção pode estar em modo Visual (x) ou Select (s, via mouse/Shift+setas).
-- No modo Select, <C-g> passa para Visual antes de rodar o comando.
local function sel(lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc }, opts or {})
  map("x", lhs, rhs, opts)
  map("s", lhs, type(rhs) == "string" and "<C-g>" .. rhs or rhs, opts)
end

local function term()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end

-- Arquivo -------------------------------------------------------------------
-- Ctrl+S (salvar) já vem do LazyVim
map({ "n", "i" }, "<C-n>", "<cmd>enew<cr>", { desc = "Novo arquivo" })
map({ "n", "i" }, "<C-w>", function() Snacks.bufdelete() end, { desc = "Fechar aba" })
map({ "n", "i" }, "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Próxima aba" })
map({ "n", "i" }, "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Aba anterior" })
map("n", "<leader>h", function() Snacks.dashboard() end, { desc = "Tela inicial" })
map({ "n", "i" }, "<C-PageDown>", "<cmd>BufferLineCycleNext<cr>", { desc = "Próxima aba" })
map({ "n", "i" }, "<C-PageUp>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Aba anterior" })

-- Copiar / colar / desfazer -------------------------------------------------
-- Sem seleção, Ctrl+C / Ctrl+X pegam a linha inteira (igual ao VSCode)
map("n", "<C-c>", '"+yy', { desc = "Copiar linha" })
map("i", "<C-c>", '<C-o>"+yy', { desc = "Copiar linha" })
sel("<C-c>", '"+y', "Copiar")
map("n", "<C-x>", '"+dd', { desc = "Recortar linha" })
map("i", "<C-x>", '<C-o>"+dd', { desc = "Recortar linha" })
sel("<C-x>", '"+d', "Recortar")
map("n", "<C-v>", '"+P', { desc = "Colar" })
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Colar" })
sel("<C-v>", '"+P', "Colar")
map("n", "<C-z>", "u", { desc = "Desfazer" })
map("i", "<C-z>", "<C-o>u", { desc = "Desfazer" })
sel("<C-z>", "<Esc>u", "Desfazer")
for _, lhs in ipairs({ "<C-y>", "<C-S-z>" }) do
  map("n", lhs, "<C-r>", { desc = "Refazer" })
  map("i", lhs, "<C-o><C-r>", { desc = "Refazer" })
end
map("n", "<C-a>", "ggVG<C-g>", { desc = "Selecionar tudo" })
map("i", "<C-a>", "<Esc>ggVG<C-g>", { desc = "Selecionar tudo" })
map("x", "<BS>", '"_d', { desc = "Apagar seleção" })

-- Edição de linhas ----------------------------------------------------------
map({ "n", "i", "x" }, "<A-Up>", "<A-k>", { remap = true, desc = "Mover linha para cima" })
map({ "n", "i", "x" }, "<A-Down>", "<A-j>", { remap = true, desc = "Mover linha para baixo" })
map("n", "<S-A-Down>", "<cmd>t.<cr>", { desc = "Duplicar linha abaixo" })
map("n", "<S-A-Up>", "<cmd>t-1<cr>", { desc = "Duplicar linha acima" })
map("i", "<S-A-Down>", "<cmd>t.<cr>", { desc = "Duplicar linha abaixo" })
map("i", "<S-A-Up>", "<cmd>t-1<cr>", { desc = "Duplicar linha acima" })
sel("<S-A-Down>", ":t'><cr>", "Duplicar seleção")
map("n", "<C-S-k>", '"_dd', { desc = "Apagar linha" })
map("i", "<C-S-k>", '<C-o>"_dd', { desc = "Apagar linha" })
map("i", "<C-CR>", "<C-o>o", { desc = "Nova linha abaixo" })
map("i", "<C-S-CR>", "<C-o>O", { desc = "Nova linha acima" })
map("i", "<C-BS>", "<C-w>", { desc = "Apagar palavra" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Apagar palavra à frente" })
sel("<Tab>", ">gv", "Indentar")
sel("<S-Tab>", "<gv", "Desindentar")
map("i", "<S-Tab>", "<C-d>", { desc = "Desindentar" })

-- Comentar (Ctrl+/) — o LazyVim usava para o terminal, que foi para Ctrl+'
for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
  map({ "n", "i" }, lhs, "<cmd>normal gcc<cr>", { desc = "Comentar linha" })
  sel(lhs, "gc", "Comentar seleção", { remap = true })
end

-- Buscar --------------------------------------------------------------------
map({ "n", "i" }, "<C-p>", LazyVim.pick("files"), { desc = "Abrir arquivo" })
map({ "n", "i" }, "<C-S-p>", function() Snacks.picker.commands() end, { desc = "Paleta de comandos" })
map({ "n", "i" }, "<F1>", function() Snacks.picker.commands() end, { desc = "Paleta de comandos" })
map({ "n", "i" }, "<C-f>", function() Snacks.picker.lines() end, { desc = "Buscar no arquivo" })
map({ "n", "i" }, "<C-S-f>", LazyVim.pick("live_grep"), { desc = "Buscar no projeto" })
sel("<C-S-f>", LazyVim.pick("grep_word"), "Buscar seleção no projeto")
map("n", "<C-h>", function()
  require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } })
end, { desc = "Substituir no arquivo" })
map({ "n", "i" }, "<C-S-h>", function() require("grug-far").open({ transient = true }) end, { desc = "Substituir no projeto" })
map({ "n", "i" }, "<C-g>", function()
  vim.ui.input({ prompt = "Ir para a linha: " }, function(n)
    n = tonumber(n)
    if n then vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(n, vim.api.nvim_buf_line_count(0))), 0 }) end
  end)
end, { desc = "Ir para a linha" })

-- Painéis -------------------------------------------------------------------
map({ "n", "i" }, "<C-b>", function() Snacks.explorer() end, { desc = "Explorador de arquivos" })
map({ "n", "i" }, "<C-S-e>", function() Snacks.explorer() end, { desc = "Explorador de arquivos" })
map({ "n", "i" }, "<C-S-g>", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end, { desc = "Git (lazygit)" })
map({ "n", "i" }, "<C-S-m>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problemas" })
-- Terminal: Ctrl+' (teclado ABNT) ou Ctrl+`
for _, lhs in ipairs({ "<C-'>", "<C-`>" }) do
  map({ "n", "i" }, lhs, term, { desc = "Terminal" })
  map("t", lhs, "<cmd>close<cr>", { desc = "Esconder terminal" })
end

-- Código (LSP) --------------------------------------------------------------
map({ "n", "i" }, "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Ir para definição" })
map({ "n", "i" }, "<S-F12>", function() Snacks.picker.lsp_references() end, { desc = "Referências" })
map({ "n", "i" }, "<F2>", vim.lsp.buf.rename, { desc = "Renomear símbolo" })
map({ "n", "i", "x" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Ações rápidas" })
map({ "n", "i" }, "<C-t>", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Símbolos do projeto" })
map({ "n", "i" }, "<F8>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Próximo problema" })
map({ "n", "i" }, "<S-F8>", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Problema anterior" })
map({ "n", "i" }, "<S-A-f>", function() LazyVim.format({ force = true }) end, { desc = "Formatar documento" })
map({ "n", "i" }, "<A-z>", function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Quebra de linha" })
map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Ir para definição" })

-- Colinha de atalhos (Ctrl+K Ctrl+S, como no VSCode) ------------------------
local function atalhos()
  Snacks.win({
    file = vim.fn.stdpath("config") .. "/ATALHOS.md",
    width = 0.75,
    height = 0.85,
    border = "rounded",
    title = " Atalhos (q para fechar) ",
    wo = { wrap = true, conceallevel = 2, spell = false },
    bo = { modifiable = false },
  })
end
vim.api.nvim_create_user_command("Atalhos", atalhos, { desc = "Colinha de atalhos" })
map({ "n", "i" }, "<C-k><C-s>", atalhos, { desc = "Colinha de atalhos" })

-- Menu do botão direito -----------------------------------------------------
pcall(vim.api.nvim_del_augroup_by_name, "nvim.popupmenu")
pcall(vim.api.nvim_del_augroup_by_name, "nvim_popupmenu")
vim.cmd([[
  silent! aunmenu PopUp
  vnoremenu PopUp.Recortar                 "+d
  vnoremenu PopUp.Copiar                   "+y
  nnoremenu PopUp.Colar                    "+P
  vnoremenu PopUp.Colar                    "+P
  inoremenu PopUp.Colar                    <C-r><C-o>+
  anoremenu PopUp.-1-                      <Nop>
  nnoremenu PopUp.Ir\ para\ definição      <cmd>lua Snacks.picker.lsp_definitions()<cr>
  nnoremenu PopUp.Referências              <cmd>lua Snacks.picker.lsp_references()<cr>
  nnoremenu PopUp.Renomear\ símbolo        <cmd>lua vim.lsp.buf.rename()<cr>
  nnoremenu PopUp.Ações\ rápidas           <cmd>lua vim.lsp.buf.code_action()<cr>
  anoremenu PopUp.-2-                      <Nop>
  nmenu     PopUp.Comentar                 gcc
  vmenu     PopUp.Comentar                 gc
  nnoremenu PopUp.Selecionar\ tudo         ggVG<C-g>
]])
