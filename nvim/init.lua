-- Options de base 
-- ~/.config/nvim/init.lua (version Jean-Pierre Laroche, 2026)
--.~/ with Mistral AI, which taught me a great deal


-- 1. Force l'encodage UTF-8 pour les fichiers et le terminal
vim.opt.encoding = 'utf-8'        -- Encodage interne de Neovim
vim.opt.fileencoding = 'utf-8'    -- Encodage des fichiers ouverts/sauvegardés

-- Configuration de base pour Neovim (120x45)
vim.opt.number = true          -- Affiche les numéros de ligne (sauf dans le terminal)
vim.opt.tabstop = 4            -- 4 espaces pour les tabulations (Rust/Zig)
vim.opt.shiftwidth = 4         -- Idem pour l'indentation
vim.opt.colorcolumn = "120"    -- Ligne verticale à 120 caractères (votre standard)
vim.opt.expandtab = true       -- Remplace les tabulations par des espaces (pour cohérence)
vim.opt.termguicolors = true   -- Pour les couleurs VTE 

vim.opt.colorcolumn = "120"  -- Ligne verticale à 120 caractères (votre standard)

-- Police (Source Code Pro, comme dans vos mémos)
vim.opt.guifont = "Fira Code Regular:h13"  -- Ajustez la taille (h12, h13, etc.) selon vos besoins


-- recherche
vim.opt.ignorecase = true -- ignore la casse quand on recherche
vim.opt.smartcase = true -- sauf quand on fait une recherche avec des majuscules, on rebascule en 
vim.opt.signcolumn = "yes"


vim.bo.swapfile = false  -- Désactive les fichiers swap pour les buffers LSP
vim.bo.undofile = false  -- Désactive l'undo persistant 
vim.bo.synmaxcol = 2000  -- Limite la coloration syntaxique aux 2000 premières colonnes 


vim.opt.iskeyword:append("-") -- on traite les mots avec des - comme un seul mot


max_width = 120               -- Lignes de 120 caractères 
comment_width = 120           -- Lignes de 120 caractères 
wrap_comments = false

-- Optimise la réactivité de <Esc> (utile avec VTE)
vim.opt.ttimeoutlen = 10  -- Délai en millisecondes (10ms = réactivité maximale)
vim.opt.timeout = true    -- Active le délai
vim.opt.timeoutlen = 500  -- Délai pour les séquences de touches (ex: <Esc>+O)

-- Surligner la ligne du curseur
vim.opt.cursorline = true

--***************************************************
-- maping base  key 

--1. Désactive F1, F3-F11 (laisse F2 et F12)
for i = 1, 11 do
  if i ~= 2 then  -- Garde F2 (F12 n'est pas dans 1-11, donc pas besoin de l'exclure)
   vim.keymap.set({'n', 'i'}, '<F' .. i .. '>', '<Nop>')
  end
end

-- Autorise uniquement les commandes de base
local allowed_commands = {
  y = true,   -- copier (yank)
  p = true,   -- coller (put)
  d = true,   -- supprimer (delete) select
  u = true,   -- annuler (undo)
  ["Ctrl+r"] = true, -- rétablir (redo)
  n = true,   -- recherche suivante
  N = true,   -- recherche précédente
  o = true, -- modes insertion
  v = true,   -- mode visuel
  ["<Esc>"] = true, -- quitter le mode insertion/remplacement
}
--  h = true, j =true, k = true, l = true, -- déplacements
--  x = true,   -- sauvegarder et quitter
--  ["/"] = true, -- recherche
--  q = true,   -- quitter
--  w = true,   -- sauvegarder
--  d = true,   -- supprimer (delete) select
--  a = true,   -- modes insertion

-- Désactive tout le reste en mode normal
vim.keymap.set('n', ':',
  function()
    local input = vim.fn.getcmdline():match('^[%a]+')
    if not allowed_commands[input] then
      print("Commande désactivée. Utilise :w, :q, y, p, d, u, /, etc.")
      return ''
    end
    return ':'
  end,
  { expr = true }
)


-- use keyboard  ex i = Ins , x = del..
--vim.keymap.del('n', ':')   -- ON
vim.keymap.set('n', 'i', '<Esc>')  -- `OFF`
vim.keymap.set({'n','v'}, 'x', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'h', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'j', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'k', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'l', '<Esc>')  -- `OFF`
vim.keymap.set('n', '/', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'q', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'w', '<Esc>')  -- `OFF`
vim.keymap.set({'n','v'}, 'd', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'a', '<Esc>')  -- `OFF`

--*****************************************************************



-- Désactive remplacement 
vim.keymap.set('i', '<Insert>', function()
    vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235]])
    vim.cmd('stopinsert') 
    vim.cmd([[ execute "normal! \<ESC>" ]])
end, { silent = true, noremap = true })
-- Désactive insertion
vim.keymap.set('n', 's', function()
    vim.cmd('stopinsert') 
    vim.cmd([[ execute "normal! \<ESC>" ]])
end, { silent = true, noremap = true })
-- =============================================
-- Configuration du presse-papiers (install parcellite xclip xsel)
-- =============================================
vim.cmd(':set clipboard+=unnamedplus')
vim.g.clipboard = {
  name = 'xclip',
  copy = { ['+'] = 'xclip -selection primary', ['*'] = 'xclip -selection clipboard' },
  paste = { ['+'] = 'xclip -selection primary -o', ['*'] = 'xclip -selection clipboard -o' },
  cache_enabled = true,
}
-- Mappings (corrigés et testés)
vim.keymap.set('v', '<C-c>', '"*y', { noremap = true, desc = "Copy to primary" })
vim.keymap.set({'n', 'v'}, '<C-v>', '"*p', { noremap = true, desc = "Paste from clipboard" })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, desc = "Paste in insert mode" })
vim.keymap.set({'n', 'v'}, '<C-d>', '"_d', { noremap = true, desc = "Delete selected text" })



--______________________________________________________________

Statusline = {}


-- Définis la barre de statut 
function Statusline.active()

    local filename = vim.fn.expand("%:t")  -- Nom du fichier (ex: "main.rs")
    local position = string.format("[%d:%d]", vim.fn.line("."), vim.fn.col("."))  -- Ex: "[42:10]"
    local modified = vim.bo.modified and "[+]" or ""  -- "[+]" si modifié, sinon ""
    local smode = string.format("%s",vim.fn.mode())
    -- Calcul du padding pour atteindre max_width (120) :
    local padding = string.rep(" ", max_width - #filename - #position - #smode - #modified -30)
-- change color for insert
vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235]])
if (smode == "i")  then vim.cmd([[highlight CursorLine guibg=#00005f ctermbg=17 ]]) end

    return string.format("[%s]%s position:%s    :mode:%s    modifier:%s", filename, padding, position, smode, modified)
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


-- Titre automatique pour les fichiers
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = vim.api.nvim_create_augroup("AutoTitle", { clear = true }),
    callback = function()
        local filename = vim.fn.expand("%:t")
        if filename and filename ~= "" then
            vim.fn.chansend(vim.v.stderr, string.format("\27]0;%s\007", filename))
        end
    end,
})


-- =============================================
-- Configuration LSP pour Rust (version optimisée)
-- =============================================

-- 1. Fonction d'attachement (améliorée)
local on_attach = function(client, bufnr)
  -- Désactive le formatage automatique (comme tu le préfères)
  client.server_capabilities.documentFormattingProvider = false

  -- Configuration de la complétion
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.keymap.set('i', '<C-x><C-o>', '<C-x><C-o>', { buffer = bufnr, desc = "Complétion LSP" })

  -- Configuration des diagnostics (version améliorée)
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",  -- Symbole devant les erreurs
      spacing = 4,    -- Espacement pour la lisibilité
      source = "always",  -- Affiche toujours la source (ex: "rustc")
    },
    signs = true,    -- Icônes dans la marge
    update_in_insert = true,  -- Désactivé en insertion (moins intrusif)
    severity_sort = true,
    float = {
      border = "rounded",
      focusable = false,
      source = "always",  -- Affiche la source dans les floats
    },
  })

  -- Affichage des diagnostics au survol (comme avant)
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false })
    end,
  })
end

-- 2. Capacités LSP (basique mais complète)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = { properties = { 'documentation', 'detail', 'additionalTextEdits' } },
}


vim.lsp.config.rust_analyzer = {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { vim.env.HOME .. '/.cargo/bin/rust-analyzer' },  -- Chemin absolu
  filetypes = { 'rust' },
  root_markers = { "Cargo.toml", ".git" },  -- Marqueurs de racine
  single_file_support = true,  -- Support des fichiers uniques

  settings = {
    ['rust-analyzer'] = {
      diagnostics = { enable = true },  -- Diagnostics activés
      cargo = {
        loadOutDirsFromCheck = false,  -- Évite les problèmes de cache
        buildScripts = { enable = true },  -- Active les scripts de build
      },
      procMacro = { enable = true },  -- Active les macros

      checkOnSave = {
        enable = true, 
        command = "clippy",  -- Utilise Clippy pour les vérifications
      },
      rustfmt = {
        extraArgs = { "--config", "max_width=120" },  -- Largeur de ligne
      },
    },
  },

  -- 4. Initialisation (comme dans ta config)
  before_init = function(init_params, config)
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
  end,
}


-- 5. Active le LSP
vim.lsp.enable("rust_analyzer")

-- =============================================
-- Gestion des erreurs 
-- =============================================

-- Fonction pour afficher les erreurs en bas (améliorée)
function _G.show_diagnostics()
  local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  if #diagnostics > 0 then
    vim.diagnostic.setloclist({ open = false })
    vim.cmd("lopen")
  else
    vim.cmd("lclose")
  end
end

-- Affichage automatique après sauvegarde (avec délai)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.rs",
  callback = function()
    vim.defer_fn(function() show_diagnostics() end, 500)  -- Délai de 500ms
  end
})

-- Raccourcis pour naviguer entre les erreurs (comme avant)
vim.keymap.set({ 'n', 'i' }, '<A-n>', ':lnext<CR>', { desc = "Erreur suivante" })
vim.keymap.set({ 'n', 'i' }, '<A-p>', ':lprev<CR>', { desc = "Erreur précédente" })
vim.keymap.set({ 'n', 'i' }, '<A-c>', ':lclose<CR>', { desc = "Fermer la liste des erreurs" })
vim.keymap.set({ 'n', 'i' }, '<A-l>', ':lopen<CR>', { desc = "Ouvrir la liste des erreurs" })



--formate le prjet 
vim.keymap.set('n', '<F2>', function()
  local cwd = vim.fn.getcwd()
  print("Formatage dans : " .. cwd)
  local output = vim.fn.system('cd ' .. cwd .. ' && cargo  fmt  -q  --all 2>&1')
  if vim.v.shell_error == 0 then
    print("✅ Projet formaté !")
    vim.cmd('checktime')  -- Recharge les fichiers modifiés
  else
    print("❌ Échec : " .. output)
  end
end, { desc = "Formater le projet (F2)", silent = false })


--______________________________________________________________
-- query erreurs les erreur 
vim.keymap.set({ 'i','n'}, '<F12>', function()

  vim.cmd('write!')  --sauvegarde forcé

  vim.diagnostic.reset()  -- Nettoie les erreurs précédentes

  -- Exécute cargo check (plus rapide que build) 
  vim.fn.system('cargo check')
  vim.diagnostic.setloclist() -- force à afficher la liste de message

  if vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
end, { desc = "[Rust] Check + Sauvegarde (F12)" })

--______________________________________________________________

vim.keymap.set('n', '<A-d>', function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  print("Diagnostics en ligne : " .. (not current and "ON" or "OFF"))
end, { desc = "Basculer les diagnostics en ligne" })


--______________________________________________________________
-- les plugins
--______________________________________________________________

vim.cmd('packadd nvim-comment')
require('nvim_comment').setup()
-- Mapping pour commenter un bloc en mode visuel
vim.keymap.set('v', '<C-t>', ':CommentToggle<CR>', { desc = "Commenter le bloc" })



local ibl = require("ibl")
vim.cmd([[
  highlight IblIndentChar guifg=#262626 ctermbg=235
]])
ibl.setup({
    indent = { char = "│", highlight = {"IblIndentChar"} },
    scope = { enabled = false },
})



--______________________________________________________________
--les commandes 
-- sauvegarde  
vim.keymap.set({'i','n'}, '<C-s>', function() 
vim.cmd(':write!')
if vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
end, { desc = "Sauvegarder" })



-- Raccourcis en mode NORMAL 
vim.keymap.set('n', '<A-q>', ':qa!<CR>', { desc = "quit full hard no backup" })

vim.keymap.set('n', '<A-s>', '/', { desc = "Search" })  -- `query search`




vim.keymap.set('n', '<A-a>', function()
  local path = "/home/soleil/Zsnipset"
  if vim.fn.filereadable(path) == 1 then
    vim.cmd(':vsplit ' .. path)  else
    print("Chemin introuvable : " .. path)
  end
end, { desc = "Ouvrir Zsnipset verticale" })


vim.keymap.set('n', '<A-w>', ':vnew<CR>:wincmd l<CR>', { desc = "new Split verticale" })  -- `vsplit_new`
vim.keymap.set('n', '<A-v>', ':vsplit<CR>:wincmd l<CR>', { desc = "Split verticale" })  -- `vsplit`
vim.keymap.set('n', '<A-x>', ':q<CR>', { desc = "Fermer la fenêtre courante du split sans quitter Neovim" })




vim.keymap.set('n', '<A-g>', 'G', { desc = "Aller à la dernière ligne" })  -- `goto_last_line`
vim.keymap.set('n', '<A-h>', vim.lsp.buf.hover, { desc = "Afficher l'aide (hover)" })  -- `hover`

vim.keymap.set('n', 'u', 'u', { desc = "Annuler" })                                  -- `undo` (déjà natif)
vim.keymap.set('n', 'r', '<C-r>', { desc = "Rétablir" })                             -- `redo` (Neovim: `<C-r>`)
vim.keymap.set('n', 'n', 'n', { desc = "Rechercher l'occurrence suivante" })         -- `search_next` (déjà natif)
vim.keymap.set('n', 'N', 'N', { desc = "Rechercher l'occurrence précédente" })       -- `search_prev` (déjà natif)

vim.keymap.set('n', '<A-u>', ':set list!<CR>', { desc = "Basculer l'affichage des caractères spéciaux" })



vim.keymap.set({'n', 'i'}, '<A-m>', '<Esc>%', { desc = "Aller à la parenthèse correspondante" })  -- `match_brackets`

-- Raccourcis en mode NORMAL ( standard keyboard )

vim.keymap.set({'n','i', 'v', 's', 'x'}, '<Esc>', function()
    vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235]])
    if vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
    vim.cmd([[ execute "normal! \<ESC>" ]])
end, { silent = true, noremap = true }) -- Réinitialise <Esc> pour un retour immédiat en mode normal

vim.keymap.set('n', '<Ins>', 'i', { desc = "mode insert" })  -- `mode Insert`
vim.keymap.set('n', '<Del>', 'x', { desc = "Supprimer le caractère sous le curseur" })  -- `delete_char_forward`
vim.keymap.set('n', '<Up>', 'k', { desc = "Monter d'une ligne" })                     -- `move_visual_line_up`
vim.keymap.set('n', '<Down>', 'j', { desc = "Descendre d'une ligne" })               -- `move_visual_line_down`
vim.keymap.set('n', '<Left>', 'h', { desc = "Aller à gauche" })                      -- `move_char_left`
vim.keymap.set('n', '<Right>', 'l', { desc = "Aller à droite" })                     -- `move_char_right`
vim.keymap.set('n', '<PageUp>', '<C-b>', { desc = "Page précédente" })               -- `page_up`
vim.keymap.set('n', '<PageDown>', '<C-f>', { desc = "Page suivante" })               -- `page_down`
vim.keymap.set('n', '<Home>', '^', { desc = "Aller au début de la ligne" })          -- `goto_line_start`
vim.keymap.set('n', '<End>', 'g_', { desc = "Aller à la fin de la ligne" })          -- `goto_line_end_newline`
vim.keymap.set('n', '<CR>', 'o', { desc = "Insérer une nouvelle ligne" })            -- `insert_newline  Enter`
--______________________________________________________________



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
vim.keymap.set({'n', 'i', 'v'}, '<A-k>', function()
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
-- Afficher les caractères spéciaux (tabulations, espaces, sauts de ligne)
vim.opt.list = true
vim.opt.listchars = {
  eol = '¶',       -- Saut de ligne
}
--______________________________________________________________

-- comment    Light Salmon
-- string     Green
-- number     Orange
-- keyword    dark Orange
-- function   Deep Sky Blue
-- type       Yelow
-- identifier orchid
-- coolean    Wheat
-- error      red
-- nontext    back red
-- constant   Dark Olive Green

-- https://www.ditig.com/256-colors-cheat-sheet


vim.cmd([[
  highlight Comment guifg=#af875f ctermfg=137 gui=none
  highlight String guifg=#00af00 ctermfg=34 gui=none
  highlight Number guifg=#ffaf00 ctermfg=214 gui=none
  highlight Keyword guifg=#ff8700 ctermfg=208 gui=none
  highlight Function guifg=#51afef ctermfg=39 gui=none
  highlight Type guifg=#d7d700 ctermfg=184 gui=none
  highlight Identifier guifg=#d75fff ctermfg=170 gui=none
  highlight Boolean guifg=#87875f ctermfg=101 gui=none
  highlight Error guifg=#ff0000 ctermfg=196 gui=none
  highlight NonText guifg=#461613 gui=none
  highlight Constant guifg=#87af5f ctermfg=107 guibg=none


  highlight CursorLine guibg=#262626 ctermbg=235
  highlight CursorColumn guibg=#262626 ctermbg=235
  set cursorcolumn

  highlight Cursor guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=reverse cterm=reverse

  set guicursor=n-v-c:block-blinkon300-blinkoff300
  set guicursor+=i-ci-ve:block-blinkon300-blinkoff300
  set guicursor+=r-cr:hor20,o:hor20


  highlight statusline guibg=#000000 guifg=#ff0000 gui=none

  highlight DiagnosticError guifg=#ff0000 guibg=NONE ctermfg=196 gui=bold
  highlight DiagnosticWarn guifg=#ffaf00 guibg=NONE ctermfg=214 gui=bold
  highlight DiagnosticInfo guifg=#51afef guibg=NONE ctermfg=39 gui=bold
  highlight DiagnosticHint guifg=#87af5f guibg=NONE ctermfg=107 gui=bold

]])
--set colorcolumn=120
--   set guicursor+=i-ci-ve:ver25



