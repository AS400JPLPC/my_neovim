-- Options de base (comme Helix, sans verbosité)
vim.opt.number = true          -- Numéros de ligne
vim.opt.tabstop = 4            -- Tabulations à 4 espaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true    -- Pour les couleurs VTE (Memory n°2)
-- Définit une largeur de texte généreuse (optionnel)
max_width = 120       -- Lignes de 120 caractères 
comment_width = 120       -- Lignes de 120 caractères 
wrap_comments = false



-- Configuration optimisée pour rust-analyzer (avec lspconfig)
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup({
  cmd = { os.getenv('HOME') .. '/.cargo/bin/rust-analyzer' },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        features = 'all',
        buildScripts = { enable = true },
      },
      check = {
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      checkOnSave = {
        enable = true,
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      rustfmt = {
        extraArgs = {
          "--comment-width=120",
          "--wrap-comments=false",
        },
      },
      procMacro = { enable = true },
      files = {
        excludeDirs = { "target/", ".git/" },
      },
      -- Réduit la verbosité des logs
      logs = {
        level = "error",  -- Affiche seulement les erreurs (pas les warnings)
      },
      cachePriming = { enable = false },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end
    })
  end,
})




-- Désactive les logs LSP (pour éviter la pollution)
vim.lsp.set_log_level("warn")  -- N'affiche que les warnings et erreurs (pas les infos)



-- Configuration pour les diagnostics (version ultra-simple)
vim.diagnostic.config({
  virtual_text = { prefix = "●" },  -- Symbole devant les erreurs
  virtual_text = true,  -- Affiche les erreurs en ligne
  signs = true,         -- Icônes dans la marge
  update_in_insert = false,
  float = { border = "rounded" },
})

-- Fonction pour afficher les erreurs en bas
function _G.show_diagnostics()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics > 0 then
    vim.diagnostic.setloclist()  -- Remplit la location-list avec les erreurs
    vim.cmd("lopen")             -- Ouvre la liste en bas
  else
    vim.cmd("lclose")            -- Ferme la liste si pas d'erreurs
  end
end

-- Affichage automatique après sauvegarde
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.rs",
  callback = function()
    vim.defer_fn(function() show_diagnostics() end, 500)  -- Délai de 500ms
  end
})

-- Naviguer entre les erreurs
vim.keymap.set('n', '<A-n>', ':lnext<CR>', { desc = "Erreur suivante" })
vim.keymap.set('n', '<A-p>', ':lprev<CR>', { desc = "Erreur précédente" })
vim.keymap.set('n', '<A-c>', ':lclose<CR>', { desc = "Fermer la liste des erreurs" })

vim.keymap.set('i', '<A-n>', ':lnext<CR>', { desc = "Erreur suivante" })
vim.keymap.set('i', '<A-p>', ':lprev<CR>', { desc = "Erreur précédente" })
vim.keymap.set('i', '<A-c>', ':lclose<CR>', { desc = "Fermer la liste des erreurs" })


-- Charger le plugin Comment.nvim
vim.cmd('packadd nvim-comment')
-- Configuration de Comment.nvim
require('nvim_comment').setup()





-- Désactiver les touches de fonction (comme dans Helix)  
for i =1, 12 do
  vim.keymap.set({'n', 'i'}, '<F' .. i .. '>', '<Nop>')
end


--les commandes 
-- copy delete paste sont integre dans le system neovim 


-- Raccourcis en mode NORMAL (équivalent à [keys.normal])
vim.keymap.set('n', '<C-a>', ':vsplit /home/soleil/Zsnipset<CR>', { desc = "Ouvrir Zsnipset dans une split verticale" })
vim.keymap.set('n', '<C-s>', ':write<CR>', { desc = "Sauvegarder" })
vim.keymap.set('n', '<A-q>', '/', { desc = "Rechercher" })  -- `qery search`
vim.keymap.set('n', '<A-m>', '%', { desc = "Aller à la parenthèse correspondante" })  -- `match_brackets`
vim.keymap.set('n', '<A-w>', ':vnew<CR>', { desc = "new Split verticale" })  -- `vsplit_new`
vim.keymap.set('n', '<A-v>', ':vsplit<CR>', { desc = "Split verticale" })  -- `vsplit`
vim.keymap.set('n', '<A-g>', 'G', { desc = "Aller à la dernière ligne" })  -- `goto_last_line`
vim.keymap.set('n', '<A-h>', vim.lsp.buf.hover, { desc = "Afficher l'aide (hover)" })  -- `hover`

-- Mapping pour commenter un bloc en mode visuel
vim.keymap.set('v', '<C-t>', ':CommentToggle<CR>', { desc = "Commenter le bloc" })




-- Raccourcis en mode INSERT (équivalent à [keys.insert])
vim.keymap.set('i', '<C-s>', '<Esc>:write<CR>a', { desc = "Sauvegarder et rester en mode insert" })
--vim.keymap.set('i', '<C-t>', '<Esc>:lua vim.cmd("normal! gcc")<CR>a', { desc = "Commenter la ligne" })
vim.keymap.set('i', '<A-m>', '<Esc>%', { desc = "Aller à la parenthèse correspondante" })



vim.keymap.set('n', '<Del>', 'x', { desc = "Supprimer le caractère sous le curseur" })  -- `delete_char_forward`
vim.keymap.set('n', '<Up>', 'k', { desc = "Monter d'une ligne" })                     -- `move_visual_line_up`
vim.keymap.set('n', '<Down>', 'j', { desc = "Descendre d'une ligne" })               -- `move_visual_line_down`
vim.keymap.set('n', '<Left>', 'h', { desc = "Aller à gauche" })                      -- `move_char_left`
vim.keymap.set('n', '<Right>', 'l', { desc = "Aller à droite" })                     -- `move_char_right`
vim.keymap.set('n', '<PageUp>', '<C-b>', { desc = "Page précédente" })               -- `page_up`
vim.keymap.set('n', '<PageDown>', '<C-f>', { desc = "Page suivante" })               -- `page_down`
vim.keymap.set('n', '<Home>', '^', { desc = "Aller au début de la ligne" })          -- `goto_line_start`
vim.keymap.set('n', '<End>', 'g_', { desc = "Aller à la fin de la ligne" })          -- `goto_line_end_newline`
vim.keymap.set('n', '<CR>', 'o', { desc = "Insérer une nouvelle ligne" })            -- `insert_newline` (en mode normal, `<CR>` = `o` pour une nouvelle ligne)




vim.keymap.set('n', 'u', 'u', { desc = "Annuler" })                                  -- `undo` (déjà natif)
vim.keymap.set('n', 'r', '<C-r>', { desc = "Rétablir" })                             -- `redo` (Neovim: `<C-r>`)

vim.keymap.set('n', 'n', 'n', { desc = "Rechercher l'occurrence suivante" })         -- `search_next` (déjà natif)
vim.keymap.set('n', 'N', 'N', { desc = "Rechercher l'occurrence précédente" })       -- `search_prev` (déjà natif)


vim.keymap.set('n', '<M-ù>', ':set list!<CR>', { desc = "Basculer l'affichage des caractères spéciaux" })



-- Configuration des couleurs (thème minimaliste)
vim.opt.background = "dark"  -- Fond sombre
--highlight Comment guifg=#af875f ctermfg=137    -- Commentaires brun
--highlight String guifg=#00af00 ctermfg=34      -- Chaînes en vert
--highlight Keyword guifg=#ff8700 ctermfg=208    -- Mots-clés Rust en orange
--highlight Function guifg=#51afef ctermfg=39    -- Fonctions en bleu
--highlight Type guifg=#d7d700 ctermfg=184       -- Types en jaune
--highlight Identifier guifg=#d75fff ctermfg=170 -- identifier Orchid
--highlight Error guifg=#ff0000 guibg=NONE ctermfg=196

vim.cmd([[
  highlight Comment guifg=#af875f ctermfg=137
  highlight String guifg=#00af00 ctermfg=34
  highlight Keyword guifg=#ff8700 ctermfg=208
  highlight Function guifg=#51afef ctermfg=39
  highlight Type guifg=#d7d700 ctermfg=184
  highlight Identifier guifg=#d75fff ctermfg=170
  highlight Error guifg=#ff0000 guibg=NONE ctermfg=196
]])




-- Options pour afficher les tabulations comme 4 espaces (alignement horizontal clair)
vim.opt.tabstop = 4      -- Une tabulation = 4 colonnes (déjà dans votre config)
vim.opt.shiftwidth = 4   -- Indentation automatique à 4 colonnes
vim.opt.expandtab = true -- Remplace les tabulations par des espaces (pour cohérence)

-- Afficher les caractères spéciaux (tabulations, espaces, sauts de ligne)
vim.opt.list = true
vim.opt.listchars = {
  eol = '¶',       -- Saut de ligne
}
vim.cmd([[
  highlight NonText  guifg=#461613
]])

-- Surligner la ligne du curseur
vim.opt.cursorline = true
vim.cmd([[
  highlight CursorLine guibg=#1c1c1c ctermbg=234
]])

-- Configuration minimaliste pour ibl (anciennement indent-blankline)
local ibl = require("ibl")
ibl.setup()
vim.cmd([[
  highlight IblIndentChar guifg=#1c1c1c ctermfg=234
]])
ibl.setup({
  indent = {
    char = "│",
    highlight = {"IblIndentChar"},
  },
  scope = { enabled = false },
})




-- Aller à une ligne avec `<A-g>` (ex: `<A-g>120`)
vim.keymap.set('n', '<C-g>', function()
  local line = vim.fn.input('Ligne: ')
  if line ~= '' then
    vim.cmd(':' .. line)
  end
end, { desc = "Aller à la ligne" })





-- Fermer le buffer courant et revenir sur netrw (version ultra-minimaliste)
vim.keymap.set('n', '<C-e>', function()
  vim.cmd('only')  -- Ne garder qu'une seule fenêtre
  vim.cmd('bd')    -- Fermer le buffer courant (sans vérification)
  vim.cmd('Ntree') -- Ouvrir netrw dans la fenêtre courante
  print(" ")
end, { desc = "Fermer le buffer et revenir sur l'explorateur de fichiers" })


-- Vide l'historique 
vim.keymap.set('n', '<C-l>', function()
  vim.fn.histdel('/', -1)
  vim.fn.histdel('?', -1)
  vim.fn.histdel(':', -1)
  vim.cmd('nohlsearch')
  print("Historique  vidé.")
end, { noremap = true, silent = false })

