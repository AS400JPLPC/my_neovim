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








--vim.opt.swapfile = false -- on supprime le pénible fichier de sw

--vim.opt.undofile = true -- on autorise l'undo à l'infini (même quand on revient sur un fichier qu'on avait fermé)

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



--______________________________________________________________
-- Désactiver les touches de fonction    F1..F11

for i = 1, 11 do
   vim.keymap.set({'n', 'i'}, '<F' .. i .. '>', '<Nop>')
end

--______________________________________________________________


-- =============================================
-- Configuration du presse-papiers (install parcellite xclip)
-- =============================================
vim.opt.clipboard:append({ "unnamedplus" })  -- Utilise le registre `+` pour le presse-papiers système
vim.g.clipboard = {
  name = 'xclip',
  copy = { ['+'] = 'xclip -selection clipboard', ['*'] = 'xclip -selection primary' },
  paste = { ['+'] = 'xclip -selection clipboard -o', ['*'] = 'xclip -selection primary -o' },
  cache_enabled = true,
}
-- =============================================
-- Mappings pour copier/coller/supprimer
-- =============================================
vim.keymap.set('v', '<C-c>', '"*y', { noremap = true } { desc = "copy to cliboard" })
vim.keymap.set({'n','v'}, '<C-v>', '"*p', { noremap = true } { desc = "copy from cliboard" })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true } { desc = "replace from cliboard" })
vim.keymap.set({'n', 'v'}, '<C-d>', '"d', { desc = "delete text select" })



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



--______________________________________________________________

-- Configuration optimisée pour rust-analyzer (avec lspconfig)
-- Configuration de rust-analyzer pour TERMRUST (version validée)
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup({
  cmd = { os.getenv('HOME') .. '/.cargo/bin/rust-analyzer' },  -- Chemin explicite

  settings = {
    ['rust-analyzer'] = {
      -- Gestion des dépendances et builds
      cargo = {
        features = "all",  -- Active toutes les features (comme dans vos validations Zig)
        buildScripts = { enable = true },  -- Analyse les scripts de build
      },

      -- Vérifications avec Clippy (rigueur comme en Zig)
      check = {
        command = "clippy",
        extraArgs = {
          "--no-deps",  -- Ignore les dépendances
          "--",
          "-W", "clippy::pedantic",  -- Mode strict
          "-A", "clippy::needless_return",  -- Désactive les warnings inutiles
        },
      },

      -- Vérification à la sauvegarde
      checkOnSave = {
        enable = true,
        command = "clippy",
        extraArgs = { "--no-deps" },
      },

      -- Formatage (120 colonnes, comme vos standards)
      rustfmt = {
        extraArgs = {
          "--config",
          "max_width=120",  -- Largeur fixe
          "comment_width=120",  -- Commentaires alignés
          "wrap_comments=false",  -- Pas de retour à la ligne forcé
        },
        enableRangeFormatting = true,  -- Permet le formatage de sélection (<C-f>)
      },

      -- Gestion des macros (pour vos macros externes dans TERMRUST)
      procMacro = { enable = true },

      -- Exclusions (propreté du projet)
      files = {
        excludeDirs = { "target/", ".git/" },  -- Ignore les dossiers système
      },

      -- Réduction du bruit (comme vos préférences)
      logs = { level = "warn" },  -- Seules les erreurs sont affichées

      -- Désactive les fonctionnalités intrusives
      completion = {
        postfix = { enable = false },  -- Pas de snippets automatiques
        autoimport = { enable = false },  -- Pas d'auto-imports
      },

      -- Désactive le cache (pour éviter les latences)
      cachePriming = { enable = false },
    },
  },


 

      on_attach = function(client, bufnr)
        -- Désactive le formatage automatique 
        client.server_capabilities.documentFormattingProvider = false

        -- Active la complétion LSP native 
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { buffer = bufnr })

        -- **Nouveau : Affichage des diagnostics au survol**
        vim.api.nvim_create_autocmd('CursorHold', {
          buffer = bufnr,
          callback = function()
            vim.diagnostic.open_float(nil, { focusable = false })
          end
        })
      end,
})
-- Désactive les logs LSP (pour éviter la pollution)
-- vim.lsp.set_log_level("warn")  -- N'affiche que les warnings et erreurs (pas les infos)



-- Formater la sélection Rust avec <C-F> (minimaliste)
-- se repositionne approximativement à l'origine de la commande
-- Nettoyage rapide : Utile pour formater des blocs non critiques (ex: corps de fonctions simples module *.rs)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.keymap.set('v', '<C-F>', function()
    local line = vim.fn.line("v")
    -- Sauvegarde la sélection dans un registre temporaire
    vim.cmd('noautocmd w !rustfmt --config max_width=120,comment_width=120,wrap_comments=false > /tmp/rustfmt_temp.rs')
    -- Remplace la sélection par le résultat formaté
    vim.cmd(':%!cat /tmp/rustfmt_temp.rs')
    -- Nettoie le fichier temporaire
    vim.fn.delete('/tmp/rustfmt_temp.rs')
    -- repositon normal
    vim.cmd([[ execute "normal! \<ESC>" ]])
    vim.cmd(':' .. line)
    end, { desc = "Format selection (Rust)" })
  end,
})

-- init.lua (version "laissez-faire")
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.keymap.set('v', '<C-f>', function()
      print("Formatage désactivé. Utilisez `:<C-F>` pour vérifier la syntaxe.")
    end, { desc = "Vérifie la syntaxe Rust sans formater" })
  end,
})

--______________________________________________________________

-- query erreurs
vim.keymap.set({ 'i','n'}, '<F12>', function()

  vim.cmd('write!')  --sauvegarde forcé

  vim.diagnostic.reset()  -- Nettoie les erreurs précédentes

  -- Exécute cargo check (plus rapide que build) 
  vim.fn.system('cargo check')
  vim.diagnostic.setloclist() -- force à afficher la liste de message

  if vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
end, { desc = "[Rust] Check + Sauvegarde (F11)" })


--______________________________________________________________

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
vim.keymap.set({ 'i','n'}, '<A-n>', ':lnext<CR>', { desc = "Erreur suivante" })
vim.keymap.set({ 'i','n'}, '<A-p>', ':lprev<CR>', { desc = "Erreur précédente" })
vim.keymap.set({ 'i','n'}, '<A-c>', ':lclose<CR>', { desc = "Fermer la liste des erreurs" })





--______________________________________________________________
-- les Plugins
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
vim.keymap.set('n', '<C-q>', ':qa!<CR>', { desc = "quit full hard no backup" })

vim.keymap.set('n', '<A-q>', '/', { desc = "Rechercher" })  -- `query search`




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

vim.keymap.set('n', '<M-ù>', ':set list!<CR>', { desc = "Basculer l'affichage des caractères spéciaux" })



vim.keymap.set({'n', 'i'}, '<A-m>', '<Esc>%', { desc = "Aller à la parenthèse correspondante" })  -- `match_brackets`

-- Raccourcis en mode NORMAL ( standard keyboard )

vim.keymap.set({'i', 'v', 's', 'x'}, '<Esc>', '<Esc>', { silent = true, noremap = true }) -- Réinitialise <Esc> pour un retour immédiat en mode normal
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
-- deux fonction enter
--______________________________________________________________
-- Insère une ligne en dessous, l'indente, ajoute une tabulation et reste en mode normal Enter
vim.keymap.set('n', '<C-m>', function()
  -- 1. Insère une ligne en dessous et quitte le mode insertion
  vim.cmd('normal! o\027')

  -- 2. Indente la ligne (selon le langage)
  vim.cmd('normal! ==')

  -- 3. Ajoute une tabulation au début de la ligne
  vim.cmd('normal! i\t\027')

  -- 4. Place le curseur après la tabulation
  vim.cmd('normal! j$')
end, { desc = "Nouvelle ligne indentée + tabulation", silent = true })



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
vim.keymap.set({'n', 'i', 'v'}, '<C-R>', function()
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



vim.cmd([[
  highlight Comment guifg=#af875f ctermfg=137 gui=none
  highlight String guifg=#00af00 ctermfg=34 gui=none
  highlight Number guifg=#ffaf00 ctermfg=214 gui=none
  highlight Keyword guifg=#ff8700 ctermfg=208 gui=none
  highlight Function guifg=#51afef ctermfg=39 gui=none
  highlight Type guifg=#d7d700 ctermfg=184 gui=none
  highlight Identifier guifg=#d75fff ctermfg=170 gui=none
  highlight Boolean guifg=#af5fff ctermfg=135 gui=none
  highlight Error guifg=#ff0000 ctermfg=196 gui=none
  highlight NonText guifg=#461613 gui=none

  highlight CursorLine guibg=#262626 ctermbg=235
  highlight CursorColumn guibg=#262626 ctermbg=235
  set cursorcolumn

  highlight Cursor guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=reverse cterm=reverse

  set guicursor=n-v-c:block-blinkon300-blinkoff300
  set guicursor+=i-ci-ve:block-blinkon300-blinkoff300
  set guicursor+=r-cr:hor20,o:hor20


  highlight statusline guibg=#000000 guifg=#ff0000 gui=none

]])

--set colorcolumn=120
--   set guicursor+=i-ci-ve:ver25
-- Afficher les caractères spéciaux (tabulations, espaces, sauts de ligne)
vim.opt.list = true
vim.opt.listchars = {
  eol = '¶',       -- Saut de ligne
}



