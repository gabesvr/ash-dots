-- Visual e comportamento do VSCode
return {
  -- Tema Dark Modern do VSCode
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    opts = { style = "dark", italic_comments = true },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "vscode" } },

  -- Abas sempre visíveis, com X para fechar (clique com o mouse funciona)
  {
    "akinsho/bufferline.nvim",
    opts = { options = { always_show_bufferline = true, show_buffer_close_icons = true } },
  },

  -- Explorador à esquerda mostrando arquivos ocultos, como a barra lateral do VSCode
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true, layout = { layout = { position = "left" } } },
          projects = { dev = { "~/Projects" } }, -- Espaço f p lista as pastas de ~/Projects
        },
      },
    },
  },

  -- Multicursor: Ctrl+D seleciona a próxima ocorrência, Alt+clique adiciona cursor,
  -- Ctrl+Shift+↑/↓ adiciona cursor acima/abaixo
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_mouse_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Add Cursor Up"] = "<C-S-Up>",
        ["Add Cursor Down"] = "<C-S-Down>",
        ["Select All"] = "<C-S-l>",
        ["Visual All"] = "<C-S-l>",
        ["Skip Region"] = "<C-k><C-d>",
        ["Exit"] = "<Esc>",
      }
    end,
    config = function()
      vim.keymap.set("n", "<A-LeftMouse>", "<Plug>(VM-Mouse-Cursor)", { desc = "Adicionar cursor" })
      vim.keymap.set("s", "<C-d>", "<C-g><C-d>", { remap = true, desc = "Próxima ocorrência" })
    end,
  },
}
