-- Options de base 
-- ~/.config/nvim/init.lua (version Jean-Pierre Laroche, 2026)
--.~/ with Mistral AI, which taught me a great deal


vim.opt.number = true          -- Numéros de ligne
vim.opt.tabstop = 4            -- Tabulations à 4 espaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Remplace les tabulations par des espaces (pour cohérence)
vim.opt.termguicolors = true    -- Pour les couleurs VTE 

max_width = 120       -- Lignes de 120 caractères 
comment_width = 120       -- Lignes de 120 caractères 
wrap_comments = false


--______________________________________________________________
-- Désactiver les touches de fonction    F1..F11
for i =1, 11 do
  vim.keymap.set({'n', 'i'}, '<F' .. i .. '>', '<Nop>')
end



--______________________________________________________________
--. configuration de base du statusline 

Statusline = {}

-- études et dtricotage
--function Statusline.active()
    -- %f file %l ligne  %c colonne %M  modifier
--    return "[%f]                                                                       position:[%l:%c] modifier:[%M]"
--	end

-- Définis la barre de statut 
function Statusline.active()
    local filename = vim.fn.expand("%:t")  -- Nom du fichier (ex: "main.rs")
    local position = string.format("[%d:%d]", vim.fn.line("."), vim.fn.col("."))  -- Ex: "[42:10]"
    local modified = vim.bo.modified and "[+]" or ""  -- "[+]" si modifié, sinon ""
    -- Calcul du padding pour atteindre max_width (120) :
    local padding = string.rep(" ", max_width - #filename - #position - #modified - 20)
    return string.format("[%s]%s    position:%s modifier:%s", filename, padding, position, modified)
end


function Statusline.inactive()
    return " %t"
end
	
local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    desc = "Activate statusline on focus",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.active()"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = group,
    desc = "Deactivate statusline when unfocused",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
    end,
})


--______________________________________________________________

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
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 0 then
        vim.diagnostic.setloclist({ open = false })
        vim.cmd("lopen")
    else
        vim.cmd("lclose")
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


-- Compile et exécute le code Rust actuel (sans sauvegarde préalable)
vim.keymap.set('i', '<F12>', function()
  vim.cmd('write!')  -- Sauvegarde temporaire (sans confirmation)
  vim.cmd('!cargo run')
end, { desc = "Exécute la compile Rust virtuel (F12) " })



--______________________________________________________________
-- les Plugins
vim.cmd('packadd nvim-comment')
require('nvim_comment').setup()
-- Mapping pour commenter un bloc en mode visuel
vim.keymap.set('v', '<C-t>', ':CommentToggle<CR>', { desc = "Commenter le bloc" })



local ibl = require("ibl")
vim.cmd([[
  highlight IblIndentChar guifg=#1c1c1c ctermfg=234
]])
ibl.setup({
    indent = { char = "│", highlight = {"IblIndentChar"} },
    scope = { enabled = false },
})

--______________________________________________________________
--les commandes 
-- copy delete paste sont integre dans le system neovim 


-- work  clipboard

vim.keymap.set('n', '<C-c>', '"+y', { desc = "copy to cliboard" })
vim.keymap.set('n', '<C-v>', '"+p', { desc = "copy from cliboard" })
vim.keymap.set('n', '<C-d>', '"d', { desc = "delete text select" })

vim.keymap.set('v', '<C-c>', '"+y', { desc = "copy to cliboard" })
vim.keymap.set('v', '<C-v>', '"+p', { desc = "copy from cliboard" })
vim.keymap.set('v', '<C-d>', 'd', { desc = "delete text select" })



-- Raccourcis en mode NORMAL (équivalent à [keys.normal])
vim.keymap.set('n', '<C-s>', ':write<CR>', { desc = "Sauvegarder" })
vim.keymap.set('n', '<C-q>', ':qa!<CR>', { desc = "quit full hard no backup" })

vim.keymap.set('n', '<A-q>', '/', { desc = "Rechercher" })  -- `qery search`




vim.keymap.set('n', '<A-a>', function()
  local path = "/home/soleil/Zsnipset"
  if vim.fn.filereadable(path) == 1 then
    vim.cmd(':vsplit ' .. path)
  else
    print("Chemin introuvable : " .. path)
  end
end, { desc = "Ouvrir Zsnipset verticale" })

vim.keymap.set('n', '<A-w>', ':vnew<CR>:wincmd l<CR>', { desc = "new Split verticale" })  -- `vsplit_new`
vim.keymap.set('n', '<A-v>',  ':vsplit<CR>:wincmd l<CR>', { desc = "Split verticale" })  -- `vsplit`
vim.keymap.set('n', '<A-x>', ':q<CR>', { desc = "Fermer la fenêtre courante du split sans quitter Neovim" })




vim.keymap.set('n', '<A-g>', 'G', { desc = "Aller à la dernière ligne" })  -- `goto_last_line`
vim.keymap.set('n', '<A-h>', vim.lsp.buf.hover, { desc = "Afficher l'aide (hover)" })  -- `hover`

vim.keymap.set('n', 'u', 'u', { desc = "Annuler" })                                  -- `undo` (déjà natif)
vim.keymap.set('n', 'r', '<C-r>', { desc = "Rétablir" })                             -- `redo` (Neovim: `<C-r>`)
vim.keymap.set('n', 'n', 'n', { desc = "Rechercher l'occurrence suivante" })         -- `search_next` (déjà natif)
vim.keymap.set('n', 'N', 'N', { desc = "Rechercher l'occurrence précédente" })       -- `search_prev` (déjà natif)

vim.keymap.set('n', '<M-ù>', ':set list!<CR>', { desc = "Basculer l'affichage des caractères spéciaux" })



-- Raccourcis en mode INSERT (équivalent à [keys.insert])
vim.keymap.set('i', '<C-s>', '<Esc>:write<CR>a', { desc = "Sauvegarder et rester en mode insert" })
vim.keymap.set({'n', 'i'}, '<A-m>', '<Esc>%', { desc = "Aller à la parenthèse correspondante" })  -- `match_brackets`


-- Raccourcis en mode NORMAL ( standard keyboard )
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


--______________________________________________________________
-- goto ligne       ex: Ligne:235
-- attention en mode 'v' la selection vas ce faire de l'emplacement du cursor jusqu'au n° deligne choisie
-- por les mode 'n','i' goto ligne
vim.keymap.set({'n', 'i','v'}, '<C-g>', function()
  vim.ui.input({
    prompt = "Ligne: ",
  }, function(line)
    if line and tonumber(line) then
      vim.cmd(':' .. line)
    else
      print("Saisie invalide (attendu: un numéro de ligne)")
    end
  end)
end, { desc = "Aller à la ligne" })


--______________________________________________________________
-- Fermer le buffer courant et revenir sur ntree à utiliser avec précaution
vim.keymap.set({'n','v'}, '<C-e>', function()
  vim.cmd('only')  -- Ne garder qu'une seule fenêtre
  vim.cmd('bd')    -- Fermer le buffer courant (sans vérification)
  vim.cmd('Ntree') -- Ouvrir netrw dans la fenêtre courante
  print(" ")
end, { desc = "Fermer le buffer et revenir sur l'explorateur de fichiers" })


--______________________________________________________________
-- Récupérer le dernier buffer fermé (en cas d'erreur)
vim.keymap.set({'n', 'i', 'v'}, '<C-r>', function()
  vim.cmd('e!')  -- Recharge le buffer actuel (annule les modifications non sauvegardées)
  print("↩️ Buffer actuel rechargé (modifications non sauvegardées perdues)")
end, { desc = "Recharger le buffer actuel", silent = false })



--______________________________________________________________
--[[
  Purge TOTALE de l'environnement Neovim (inspiré de QTEMP sur AS400).
  - Supprime :
    - Buffers (y compris # et erreurs).
    - Historique de navigation (Ctrl-O/Ctrl-I).
    - Presse-papiers et registres.
  - Utilisation : <C-l> pour tout nettoyer SAUF le buffer actuel.
]]


-- Purge TOTALE : buffers SAUF le buffer actuel, historique, presse-papiers, ET le buffer #
-- Version avec vérification explicite du buffer #
vim.keymap.set({'n', 'i', 'v'}, '<C-l>', function()
  local current_buf = vim.api.nvim_get_current_buf()

  -- 1  Ferme tous les buffers sauf l'actuel
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf then
      pcall(vim.cmd, 'bd! ' .. buf)
    end
  end

  -- 2  Supprime le buffer # uniquement s'il existe
  local alternate_buf = vim.fn.bufnr('#')
  if alternate_buf ~= -1 then  -- bufnr('#') retourne -1 si le buffer n'existe pas
    pcall(vim.cmd, 'bwipeout! #')
  end

  -- 3. Réinitialise l'historique de navigation
  vim.cmd('clearjumps')

  -- 4. Nettoyage classique (recherche, presse-papiers, etc.)
  vim.cmd('let @/ = "" | nohlsearch')
  vim.fn.histdel(':', -1)
  vim.fn.histdel('?', -1)
  os.execute('xclip -selection clipboard /dev/null 2>/dev/null')
  vim.fn.setreg('"', '')
  vim.fn.setreg('+', '')

  print("🧹 Tout purgé SAUF le buffer actuel (et # supprimé si possible)")
end, { desc = "Purge TOTALE (sauf buffer actuel)", silent = false })


--______________________________________________________________

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
  highlight Number guifg=#ffaf00 ctermfg=214
  highlight Keyword guifg=#ff8700 ctermfg=208
  highlight Function guifg=#51afef ctermfg=39
  highlight Type guifg=#d7d700 ctermfg=184
  highlight Identifier guifg=#d75fff ctermfg=170
  highlight Boolean guifg=#af5fff ctermfg=135
  highlight Error guifg=#ff0000 ctermfg=196
  highlight NonText guifg=#461613
  highlight CursorLine guibg=#1c1c1c ctermbg=234
]])

-- Afficher les caractères spéciaux (tabulations, espaces, sauts de ligne)
vim.opt.list = true
vim.opt.listchars = {
  eol = '¶',       -- Saut de ligne
}

-- Surligner la ligne du curseur
vim.opt.cursorline = true
