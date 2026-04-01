-- Options de base 
-- ~/.config/nvim/init.lua (version Jean-Pierre Laroche, 2026)
--.~/ with Mistral AI, which taught me a great deal
-- Configuration de base pour ntree


-- 1. Force l'encodage UTF-8 pour les fichiers et le terminal
vim.opt.encoding = 'utf-8'        -- Encodage interne de Neovim
vim.opt.fileencoding = 'utf-8'    -- Encodage des fichiers ouverts/sauvegardés


-- Configuration de base pour Neovim (120x45)
vim.opt.number = true          -- Affiche les numéros de ligne (sauf dans le terminal)
vim.opt.colorcolumn = "120"    -- Ligne verticale à 120 caractères (votre standard)
vim.opt.termguicolors = true     -- Active les couleurs 24-bit (plus intenses)


-- Utilise des VRAIES tabulations (\t) et non des espaces
vim.opt.tabstop = 4          -- Largeur d'une tabulation (affichage)
vim.opt.shiftwidth = 4       -- Largeur de l'indentation (>>, <<)
vim.opt.expandtab = false    -- Désactive la conversion des \t en espaces
vim.opt.softtabstop = 0      -- Désactive (évite les mélanges)
vim.opt.smarttab = true      -- Comportement intelligent des tabulations

-- Police (Source Code Pro, comme dans vos mémos)
vim.opt.guifont = "Fira Code Regular:h13"  -- Ajustez la taille (h12, h13, etc.) selon vos besoins


-- recherche
vim.opt.ignorecase = true -- ignore la casse quand on recherche
vim.opt.smartcase = true -- sauf quand on fait une recherche avec des majuscules
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

-- 2. Désactive l'historique de less
vim.env.LESSHISTFILE = "-"

-- 2. Configuration du dossier temporaire (unique par instance)
local tempdir = vim.fn.expand("~/.cache/nvim/tmp/tmp_" .. vim.fn.getpid())
vim.env.TMPDIR = tempdir
vim.fn.mkdir(tempdir, "p")  -- Crée le dossier s'il n'existe pas

--vim.opt.syntax = off 
--=============================================
-- maping base  key 
--=============================================

-- Désactive toutes les touches de fonction SAUF F2, F5 et F12
for i = 1, 12 do
  if i ~= 2 and i ~= 5 and i ~= 7 and i ~= 12 then  -- Garde F2, F5 et F12
    vim.keymap.set({'n', 'i', 'v'}, '<F' .. i .. '>', '<Nop>')
  end
  
  
  
end

-- Autorise uniquement les commandes de base
local allowed_commands = {
  y = true,   -- copier (yank)
  p = true,   -- coller (put)
  u = true,   -- annuler (undo)
  n = true,   -- recherche suivante
  N = true,   -- recherche précédente
  o = true, -- modes insertion
  v = true,   -- mode visuel

}
--  y = true,   -- copier (yank)
--  p = true,   -- coller (put)
--  h = true, j =true, k = true, l = true, -- déplacements
--  x = true,   -- sauvegarder et quitter
--  ["/"] = true, -- recherche
--  q = true,   -- quitter
--  w = true,   -- sauvegarder
--  d = true,   -- supprimer (delete) select
--  a = true,   -- modes insertion
-- ["Ctrl+r"] = true, -- rétablir (redo)
-- Désactive tout le reste en mode normal
--  ["<Esc>"] = true, -- quitter le mode insertion/remplacement

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

-- active for test 
--vim.keymap.del('n', ':')   -- ON



vim.keymap.set({'n','i','v'}, '<C-A>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-B>', '<Esc>')  -- `OFF`
--vim.keymap.set({'n','i','v'}, '<C-C>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-D>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-E>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-F>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-G>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-H>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-I>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-J>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-K>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-L>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-M>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-N>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-O>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-P>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-Q>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-R>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-S>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-T>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-U>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-V>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-W>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-X>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-Y>', '<Esc>')  -- `OFF`
vim.keymap.set({'n','i','v'}, '<C-Z>', '<Esc>')  -- `OFF`

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
vim.keymap.set('n', 's', '<Esc>')  -- `OFF`
vim.keymap.set('n', 'd', '<Esc>')  -- `OFF`
--*****************************************************************

-- Configuration des couleurs (appelée une seule fois)
local function setup_colors()
  vim.cmd([[
    highlight Normal guifg=#ffffff guibg=#1c1c1c cterm=NONE
    highlight Comment guifg=#af875f ctermfg=137 guibg=NONE ctermbg=NONE
    highlight String guifg=#00af00 ctermfg=34 guibg=NONE ctermbg=NONE
    highlight Number guifg=#ffaf00 ctermfg=214 guibg=NONE ctermbg=NONE
    highlight Keyword guifg=#ff8700 ctermfg=208 guibg=NONE ctermbg=NONE
    highlight Function guifg=#51afef ctermfg=39 guibg=NONE ctermbg=NONE
    highlight Type guifg=#d7d700 ctermfg=184 guibg=NONE ctermbg=NONE
    highlight Identifier guifg=#d75fff ctermfg=170 guibg=NONE ctermbg=NONE
    highlight Boolean guifg=#87875f ctermfg=101 guibg=NONE ctermbg=NONE
    highlight Error guifg=#ff0000 ctermfg=196 guibg=NONE ctermbg=NONE
    highlight Constant guifg=#87af5f ctermfg=107 guibg=NONE ctermbg=NONE
    highlight PreProc guifg=#ba9cef ctermfg=147 guibg=NONE ctermbg=NONE
    highlight CursorLine guibg=#262626 ctermbg=235 guifg=NONE ctermfg=NONE
    highlight CursorColumn guibg=#262626 ctermbg=235 guifg=NONE ctermfg=NONE
    set cursorcolumn
    highlight Cursor guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=reverse cterm=reverse
    set guicursor=n-v-c:block-blinkon300-blinkoff300
    set guicursor+=i-ci-ve:block-blinkon300-blinkoff300
    set guicursor+=r-cr:hor20,o:hor20
    highlight statusline guibg=#000000 guifg=#ff0000 cterm=NONE
    highlight DiagnosticError guifg=#ff0000 guibg=NONE ctermfg=196 ctermbg=NONE gui=bold
    highlight DiagnosticWarn guifg=#ffaf00 guibg=NONE ctermfg=214 ctermbg=NONE gui=bold
    highlight DiagnosticInfo guifg=#51afef guibg=NONE ctermfg=39 ctermbg=NONE gui=bold
    highlight DiagnosticHint guifg=#87af5f guibg=NONE ctermfg=107 ctermbg=NONE gui=bold
    highlight NonText guifg=#5a0d0d cterm=NONE guibg=NONE
    highlight IblIndentChar guifg=#3a3a3a ctermfg=237 guibg=NONE ctermbg=NONE
  ]])
end



--============================================================
-- Système de log unifié  (ex: log("⚙️ Bin Name:", bin_name))

--log("✅ rust-analyzer est actif")
-- → [01] ✅ rust-analyzer est actif

-- Cas 2: Table avec message
--log({message = "Test passé"})
-- → [02] Test passé

-- Cas 3: Table simple
--log(1, 2, 3)
-- → [03] 1, 2, 3

-- Cas 4: Table complexe
--log({status = false, details = {...}})
-- → [04] [table]

-- Cas 5: Mixte
--log("Bin Name:", "Ptest", {version = 1.0})
-- → [05] Bin Name: Ptest [table]
--============================================================
local messages = {}

-- Fonction pour formater une table de manière intelligente

local function format_table(v)
  if type(v) ~= "table" then return tostring(v) end

  -- Champs prioritaires à afficher
  local priority_fields = {"message", "details", "error", "result", "output"}
  local other_fields = {}

  -- Séparation des champs prioritaires et autres
  for k, val in pairs(v) do
    if type(val) ~= "function" then  -- On ignore les fonctions
      if vim.tbl_contains(priority_fields, k) then
        table.insert(other_fields, 1, string.format("%s=%s", k, tostring(val)))
      else
        table.insert(other_fields, string.format("%s=%s", k, tostring(val)))
      end
    end
  end

  -- Si on a des champs prioritaires, on les met en avant
  if #other_fields > 0 then
    return "{" .. table.concat(other_fields, ", ") .. "}"
  else
    return "[table vide]"
  end
end

-- Fonction log principale
function _G.log(...)
  local args = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    if type(v) == "table" then
      local parts = {}
      for k, val in pairs(v) do
        if type(val) ~= "function" then
          table.insert(parts, string.format("%s=%s", k, tostring(val)))
        end
      end
      table.insert(args, "{" .. table.concat(parts, ", ") .. "}")
    else
      table.insert(args, tostring(v))
    end
  end
  table.insert(messages, args)
end


-- Affichage (F5)
vim.keymap.set('n', '<F5>', function()
  vim.cmd('noautocmd new | setlocal buftype=nofile bufhidden=hide noswapfile')
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(buf, 'MessageHistory_' .. os.time())

  local lines = {}
  if #messages == 0 then
    table.insert(lines, "Aucun message en mémoire")
  else
    for i, msg in ipairs(messages) do
      table.insert(lines, string.format("[%02d] %s", i, table.concat(msg, " ")))
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end)

-- Effacer (F7)
vim.keymap.set('n', '<F7>', function()
  messages = {}
  print("✅ Historique effacé")
end)



--=============================================
-- Désactive remplacement 
--=============================================

vim.keymap.set('i', '<Ins>', function()
    vim.cmd('stopinsert') 

    vim.schedule(function()
        vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235 guifg=NONE ctermfg=NONE]])
    end)
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
    vim.schedule(function()
        vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235 guifg=NONE ctermfg=NONE]])
    end)

		if (smode == "i")  then 
				vim.schedule(function()
				    vim.cmd([[highlight CursorLine guibg=#00005f ctermbg=17 guifg=NONE ctermfg=NONE]])
				end)
		end

    return string.format("[%s]%s position:%s    :mode:%s    modifier:%s ", filename, padding, position, smode, modified)
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




--===============================================================
-- pour avoir un onglet portant le nom du source
--===============================================================

function _G.set_terminal_title(title)
    if not title or title == "" then return end
    local filename = vim.fn.expand("%:t")  -- Nom du fichier SEUL (ex: "fields.rs")
    local title_string = string.format("\27]0;%s\7", filename)
    io.stdout:write(title_string)
    io.stdout:flush()
    log(filename)  -- Optionnel : log le nom du fichier
end

vim.opt.title = false          -- Active la mise à jour du titre

-- Met à jour le titre avec UNIQUEMENT le nom du fichier (ex: "fields.rs")
vim.cmd([[
  autocmd BufEnter * lua set_terminal_title(vim.fn.expand("%:t"))
]])



--===============================================================
-- Configuration LSP pour Rust (version optimisée)
--===============================================================

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*",
  callback = function()
    vim.opt_local.swapfile = false
  end,
})

local original_level = function(msg, level) end
-- 1. Fonction pour filtrer les notifications
vim.notify = function(msg, level)
  if level == vim.log.levels.ERROR and not msg:find("desugared expr") then
    original_level(msg, level)  -- Affiche seulement les VRAIES erreurs
  end
end


-- 2. Fonction on_attach 
local on_attach = function(client, bufnr)

  -- Désactive le formatage automatique
  client.server_capabilities.documentFormattingProvider = false

  -- Configuration de la complétion
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.keymap.set('i', '<A-k>', '<C-x><C-o>', { buffer = bufnr, desc = "Complétion LSP" })

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Aller à la définition" })

  
  -- Configuration des diagnostics 
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4, source = "always" },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", focusable = true, source = "always" },
  })

  -- Affichage des diagnostics au survol
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false })
    end,
  })

    -- Force l'affichage des diagnostics dès l'ouverture
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = bufnr,
      callback = function()
        vim.diagnostic.show()   -- Affiche les diagnostics existants
      end,
    })

  -- Rafraîchit simplement les diagnostics après sauvegarde (sans request direct)
  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.reset()
      vim.cmd('silent! LspDocumentDiagnostics')  -- Méthode plus fiable
    end,
  })
end

-- 3. Capacités LSP
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
capabilities.workspace = {
  didChangeWatchedFiles = { dynamicRegistration = true },
}

-- 4. Configuration rust-analyzer 
vim.lsp.config('rust_analyzer', {

  on_attach = on_attach,

  capabilities = capabilities,

  cmd = { vim.env.HOME .. '/.cargo/bin/rust-analyzer' },

  filetypes = { 'rust' },

  root_markers = { "Cargo.toml", ".git" },
 
  single_file_support = true,

  settings = {
    ['rust-analyzer'] = {
      cargo = {
        buildScripts = {
          enable = true,    -- Active l'analyse des build scripts
        },
        allFeatures = true, -- Active toutes les features pour l'analyse
        loadOutDirsFromCheck = false,
        watch = true,
      },

      diagnostics = {
           enable = rust_analyzer_diagnostics_enabled,
           disabled = {"unlinked-file"},  -- Désactive le warning pour les fichiers non liés
        },

        experimental = {
          enable = true,        -- Active les fonctionnalités expérimentales (meilleure détection)
        },
      procMacro = { enable = true },

      checkOnSave = {
        enable = true,
        command = "clippy",  -- Gardez clippy pour plus de rigueur
      },

      rustfmt = {
        extraArgs = { "--config", "max_width=120" },
      },

      lens = { enable = true },  -- Affiche les références/implementation

      inlayHints = {
        enable = true,
        chainingHints = true,  -- Utile pour les méthodes enchaînées
      },
    },
  },

  before_init = function(init_params, config)
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
  end,



-- LspInfo
log("✅ Init server RUST !")
})

-- 5. Active le LSP 
vim.lsp.enable("rust_analyzer")


-- =============================================
-- Gestion des erreurs 
-- =============================================


-- Déclare la fonction une fois (évite la duplication)
local function cargo_check_errors()
  vim.cmd('write')
  local cmd = "cargo check --all-features --message-format=json 2>&1"
  local handle = io.popen(cmd)
  if not handle then return end
  local output = handle:read('*a')
  handle:close()

  local qf_list = {}

  for line in output:gmatch("[^\r\n]+") do
    local ok, data = pcall(vim.json.decode, line)
    if ok and data and data.message then
      -- Construire le texte complet de l'erreur (incluant les enfants)
      local full_text = data.message.rendered
      if data.message.level == "error" then
      -- Ajouter les messages enfants (suggestions, notes, etc.)
      if data.message.children then
        for _, child in ipairs(data.message.children) do
          full_text = child.message .. "\n"
        end
      end

--      if data.message.level == "error" then
        table.insert(qf_list, {
          filename = data.message.spans[1].file_name,
          lnum = data.message.spans[1].line_start,
          col = data.message.spans[1].column_start,
          text = full_text,  -- Utilise le texte complet avec les enfants
        })
      end
    end
  end

  vim.fn.setqflist(qf_list, 'r')
 
  if #qf_list > 0 then
    vim.fn.setqflist(qf_list, 'r')
    vim.cmd('copen')  -- Ouvre la quickfix list
    print(string.format("⚠️ %d erreur(s) détectée(s)", #qf_list))
  else
    vim.cmd('cclose')  -- Ferme la quickfix list
    vim.cmd('lclose')  -- Ferme la location list
    print("✅ Aucune erreur détectée")
  end

end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  once = true,  -- Une fois par session
  callback = function()
    if vim.fn.findfile("Cargo.toml", ".;") ~= "" then
      vim.defer_fn(cargo_check_errors, 500)
    end
  end,
})

--______________________________________________________________
-- F2-formate le projet
--______________________________________________________________
vim.keymap.set('n', '<F2>', function()
  local cwd = vim.fn.getcwd()
  print("Formatage dans : " .. cwd)
  local output = vim.fn.system('cd ' .. cwd .. ' && cargo  fmt  -q  --all 2>&1')
  if vim.v.shell_error == 0 then
    log("✅ Projet formaté !")
    print("✅ Projet formaté !")
    vim.cmd('checktime')  -- Recharge les fichiers modifiés
  else
    print("⚠️ Échec : " .. output)
  end
end, { desc = "Formater le projet (F2)", silent = false })


--______________________________________________________________
-- association des erreurs avec la gesion diagnostique  pour F12
--______________________________________________________________
-- Déclare la fonction globalement
local notifications = {}
function _G.log_error(fichier, ligne, col, message)
  -- Récupère la location list actuelle
--  local current_loclist = vim.fn.getloclist(0)


  -- Ajoute la nouvelle erreur
  table.insert(notifications, {
    filename = fichier,
    lnum = tonumber(ligne),
    col = tonumber(col),
    text = message,
  })

  -- Met à jour la location list
  vim.fn.setloclist(0, notifications)

  -- Ouvre la location list si elle n'est pas déjà ouverte
  local loclist_wins = vim.fn.getloclist(0, { winid = 0 }).winid
  if loclist_wins == 0 then
    vim.cmd('lopen')
  end

end



--______________________________________________________________
-- F12 compile feature
-- install pacman -S jq 
--______________________________________________________________
-- 1 -check projet 
local function find_first_binary_in_src_bin()
  -- Commande corrigée pour extraire le nom du premier binaire
  local cargo_toml = io.popen(
    'cargo read-manifest 2>/dev/null | jq -r \'.targets[] | select(.kind[]? | contains("bin")) | .name\' 2>/dev/null'
  )

  if cargo_toml then
    local first_bin = cargo_toml:read('*l')  -- Lit la première ligne (le nom du binaire)
    cargo_toml:close()

    -- Vérifie que le résultat est valide et non vide
    if first_bin and first_bin ~= '' and first_bin ~= 'null' then
      return first_bin
    end
  end

  return ""  -- Retourne une chaîne vide si aucun binaire trouvé
end


-- recherche binaire
local function get_build_command()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local bin_name = buf_path:match('/src/bin/([^/]+).rs$')

  -- 2. Si on est déjà dans un binaire (src/bin/xxx.rs), on l'utilise
  if bin_name ~= nil then
    return bin_name
  end

  -- 3. Sinon, on cherche le premier binaire disponible dans src/bin/
  local bin_name = find_first_binary_in_src_bin()

  if #bin_name > 0 then
    return bin_name -- Utilise le premier binaire trouvé
  end

  -- 4. Sinon, error   
  return ""
end


vim.keymap.set('n', '<F12>', function()
	vim.cmd('write')
	-- 1. Détection automatique
	local bin_name = get_build_command()


	local cmd = "cargo build --features=\"" .. bin_name .."\""
	--print("⚙️ Exécution : " .. cmd)
	--vim.cmd('sleep 3000m')  -- Pause de 3s

	root_dir = function(fname)
	-- Cherche Cargo.toml en remontant depuis fname
	local cargo_toml = vim.fs.find({'Cargo.toml'}, { upward = true, path = vim.fs.dirname(fname) }) end

	-- 2. Exécution et parsing complet
	local output = vim.fn.system(cmd .. " 2>&1")
	local qf_list = 0
	local current_error = {}

	local i = #notifications
	while  #notifications >= 1 do
		table.remove(notifications, i)  -- Supprime l'élément courant
		i = i - 1  -- Passe à l'élément suivant
	end


		
	for line in output:gmatch("[^\r\n]+") do
		if line:match('^error%[E%d+%]') then
			current_error = {text = line}
			elseif line:match('^%s*-->') then
				local file, lnum, col = line:match('%s*--> (%S+):(%d+):(%d+)')
				if file then
					local msgtext = current_error.text or line
					current_error = {
						filename = file,
						lnum = tonumber(lnum),
						col = tonumber(col),
						text = (current_error.text or "") .. "\n" .. line
					}

					-- log(current_error.filename, current_error.lnum, current_error.col,  msgtext)

					_G.log_error(current_error.filename, current_error.lnum, current_error.col,  msgtext)
					qf_list = qf_list + 1
				end
			end
		end
		if qf_list == 0 then
			log("✅ Build TEST réussi " .. bin_name)
			print("✅ Build TEST réussi")
			vim.cmd('cclose') -- ferme la iste des erreur quickfix
			vim.cmd('lclose') -- ferme la liste des erreu
		else
			log(string.format("⚠️ %d problème(s)  ",  qf_list) .. bin_name)
			print(string.format("⚠️ %d problème(s) ", qf_list) .. bin_name)
		end


end, { desc = 'Build (F12)', silent = false })

--______________________________________________________________

-- Fermeture quickfix et erreur standard
vim.keymap.set({'n','i'}, '<A-c>', function()
 -- 1. Ferme la quickfix
  vim.cmd('cclose') -- ferme la iste des erreur quickfix
  vim.cmd('lclose') -- ferme la liste des erreurs

  -- 2. Efface les diagnostics LSP (si vous utilisez un LSP comme rust-analyzer)
  vim.diagnostic.reset()

  -- 3. Rafraîchit le buffer actuel
  vim.cmd('checktime')
  vim.cmd('e!')

  print("🔄 Diagnostics et buffer réinitialisés")
end, { desc = 'Réinitialiser diagnostics', silent = false })



--_______________________________________________________
-- caractères spéciaux
--_______________________________________________________
-- Désactive l'affichage des caractères spéciaux
vim.opt.list = false

-- Configuration des fins de ligne (`¶`)
-- Crée un espace de noms global pour les fins de ligne

vim.cmd([[
  let g:EOL_NS = nvim_create_namespace('EOL')
]])
-- Fonction pour mettre à jour les `¶`
_G.update_eol = function()
  local buf = vim.api.nvim_get_current_buf()
  pcall(vim.api.nvim_buf_clear_namespace, buf, vim.g.EOL_NS, 0, -1)

  local lines = vim.api.nvim_buf_line_count(buf)
  for i = 1, lines do
    local line = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
    if not line:match("^%s*$") then  -- Ignore les lignes vides
      pcall(vim.api.nvim_buf_set_extmark, buf, vim.g.EOL_NS, i - 1, -1, {
        virt_text = {{"¶", "NonText"}},
        virt_text_pos = "overlay",
      })
    end
  end

 	vim.schedule(function()
  	vim.cmd([[highlight CursorLine guibg=#00005f ctermbg=17 guifg=NONE ctermfg=NONE]])
  end)
  
end

-- Active les `¶` automatiquement
vim.cmd([[
  autocmd BufEnter,TextChanged,InsertLeave * lua _G.update_eol()
]]
)
-- Désactive les `¶` en mode insertion
vim.cmd([[
  autocmd InsertEnter * lua vim.api.nvim_buf_clear_namespace(0, vim.g.EOL_NS, 0, -1)
]])


-- Fonction pour remplacer les espaces par des tabulations
local function convert_spaces_to_tabs()
  local spaces_to_replace = vim.opt.shiftwidth._value  -- Utilise la valeur de shiftwidth
  local spaces_pattern = string.rep(" ", spaces_to_replace)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for i, line in ipairs(lines) do
    local new_line, count = line:gsub(spaces_pattern, "\t")
    if count > 0 then
      vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
    end
  end
end

-- Déclenche cette fonction avant l'enregistrement
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    convert_spaces_to_tabs()
  end,
})



--______________________________________________________________
--les commandes 

vim.keymap.set('n', '<A-a>', function()
  local path = "/home/soleil/Zsnipset"
  if vim.fn.filereadable(path) == 1 then
    vim.cmd(':vsplit ' .. path)  else
    print("Chemin introuvable : " .. path)
  end
end, { desc = "Ouvrir Zsnipset verticale" })

--__________________________

-- Raccourcis pour naviguer entre les erreurs (comme avant)
vim.keymap.set({ 'n', 'i' }, '<A-n>', ':lnext<CR>', { desc = "Erreur suivante" })
vim.keymap.set({ 'n', 'i' }, '<A-p>', ':lprev<CR>', { desc = "Erreur précédente" })




vim.keymap.set('n', '<A-d>', function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  print("Diagnostics en ligne : " .. (not current and "ON" or "OFF"))
end, { desc = "Basculer les diagnostics en ligne" })

--__________________________


vim.keymap.set('n', '<A-g>', 'G', { desc = "Aller à la dernière ligne" })  -- `goto_last_line`

vim.keymap.set('n', '<A-h>', vim.lsp.buf.hover, { desc = "Afficher l'aide (hover)" })  -- `hover`

vim.keymap.set({'n', 'i'}, '<A-m>', '<Esc>%', { desc = "Aller à la parenthèse correspondante" })  -- `match_brackets`

vim.keymap.set({'n','t'}, '<A-q>', ':qa!<CR>', { desc = "quit full hard no backup" })


vim.keymap.set('n', '<A-s>', '/', { desc = "Search" })  -- `query search`

vim.keymap.set("n", "<A-t>", function()
    vim.cmd('let @/ = "" | nohlsearch')
end, { desc = "Effacer le surlignage de la recherche" })  -- `clear search`


vim.keymap.set('n', '<A-u>', ':set list!<CR>', { desc = "Basculer l'affichage des caractères spéciaux" })

vim.keymap.set('n', '<A-v>', ':vsplit<CR>:wincmd l<CR>', { desc = "Split verticale" })  -- `vsplit`

vim.keymap.set('n', '<A-w>', ':vnew<CR>:wincmd l<CR>', { desc = "new Split verticale" })  -- `vsplit_new`


local function close_current_split()
  -- Vérifie si on est dans un split (plus d'une fenêtre ouverte)
  if 
  vim.fn.winnr('$') > 1 then
    -- Demande confirmation
    local choice = vim.fn.confirm("Fermer la fenêtre courante du split ?", "&Oui\n&Non", 2)
    if choice == 1 then
      vim.cmd('close')  -- Ferme la fenêtre courante
    end
  end
end

-- Mapping pour lancer la fonction
vim.keymap.set('n', '<A-x>', close_current_split, { desc = "Fermer la fenêtre courante du split" })


-- Récupérer le dernier buffer fermé (en cas d'erreur)
vim.keymap.set({'n', 'i', 'v'}, '<A-z>', function()
  vim.cmd('e!')  -- Recharge le buffer actuel (annule les modifications non sauvegardées)
  print("↩️ Buffer actuel rechargé (modifications non sauvegardées perdues)")
end, { desc = "Recharger le buffer actuel", silent = false })


-- 1. Fonction de recherche interactive
local function search_word_interactive()
  vim.ui.input({
    prompt = "Mot à rechercher: ",
  }, function(word)
    if not word or word == "" then
      print("Saisie invalide (attendu: un mot)")
      return
    end

    -- Exécute la recherche avec rg

local cmd = string.format("rg --no-heading --line-number --column --word-regexp --glob '*.rs' --color=never '%s' .", word)
    local output = vim.fn.system(cmd)

    -- Vérifie si aucune occurrence n'est trouvée
    if output == "" then
      print("Aucune occurrence trouvée pour: " .. word)
      return
    end

    -- Vérifie s'il y a une erreur
    if vim.v.shell_error ~= 0 then
      vim.notify("Erreur: " .. output, vim.log.levels.ERROR)
      return
    end

    -- Parse les résultats
    local qf_list = {}
    local ns = vim.api.nvim_create_namespace("search_references")
    local current_file = vim.fn.expand('%:p')
    local count = 0

    for line in output:gmatch("[^\r\n]+") do
      local file, lnum, col, text = line:match('^(.-):(%d+):(%d+):(.*)')
      if file then
        table.insert(qf_list, {
          filename = file,
          lnum = tonumber(lnum),
          col = tonumber(col),
          text = text
        })

        -- Surligne dans le buffer actuel
        if file == current_file then
          local end_col = tonumber(col) - 1 + vim.fn.strchars(word)
          vim.api.nvim_buf_add_highlight(
            0, ns, "LspReferenceText",
            tonumber(lnum) - 1,
            tonumber(col) - 1,
            end_col
          )
          count = count + 1
        end
      end
    end

    -- Affiche dans la Location List
    if #qf_list > 0 then
      vim.fn.setloclist(0, qf_list, 'r')
      vim.cmd('lopen')
      vim.notify(string.format("⚠️ %d occurrence(s) trouvée(s)", #qf_list), vim.log.levels.INFO)
    else
      print("Aucune occurrence trouvée pour: " .. word .. " dans " .. current_file)
    end
  end)
end


-- Mapping pour lancer la recherche interactive
vim.keymap.set('n', '<A-r>', search_word_interactive, { desc = "Rechercher un mot (interactif)" })



--______________________________________________________________
-- Raccourcis en mode NORMAL ( standard keyboard )

vim.keymap.set('n', 'u', 'u', { desc = "Annuler" })                                  -- `undo` (déjà natif)
vim.keymap.set('n', 'r', '<C-r>', { desc = "Rétablir" })                             -- `redo` (Neovim: `<C-r>`)
vim.keymap.set('n', 'n', 'n', { desc = "Rechercher l'occurrence suivante" })         -- `search_next` (déjà natif)
vim.keymap.set('n', 'N', 'N', { desc = "Rechercher l'occurrence précédente" })       -- `search_prev` (déjà natif)

--______________________________________________________________

vim.keymap.set({'n','i','v','s','x'}, '<Esc>', function()
    if vim.fn.mode() == 'i' then
        vim.cmd('stopinsert')
    else
        vim.cmd([[execute "normal! \<ESC>"]])
    end
    vim.schedule(function()
        vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235 guifg=NONE ctermfg=NONE]])
    end)
end, { silent = true, noremap = true })

vim.keymap.set('n', '<Insert>',function()
		vim.cmd(":startinsert")
		vim.cmd([[highlight CursorLine guibg=#00005f ctermbg=17]])
end,{ desc = "mode insert" })  -- `mode Insert`

vim.keymap.set('n', '<C-d>', 'dd', { desc = "Supprimer ligne" })  -- `delete_char_forward
vim.keymap.set('n', '<Del>', 'x', { desc = "Supprimer le caractère sous le curseur" })  -- `delete_char_forward`
vim.keymap.set('n', '<Up>', 'k', { desc = "Monter d'une ligne" })                     -- `move_visual_line_up`
vim.keymap.set('n', '<Down>', 'j', { desc = "Descendre d'une ligne" })               -- `move_visual_line_down`
vim.keymap.set('n', '<Left>', 'h', { desc = "Aller à gauche" })                      -- `move_char_left`
vim.keymap.set('n', '<Right>', 'l', { desc = "Aller à droite" })                     -- `move_char_right`
vim.keymap.set('n', '<PageUp>', '<C-b>', { desc = "Page précédente" })               -- `page_up`
vim.keymap.set('n', '<PageDown>', '<C-f>', { desc = "Page suivante" })               -- `page_down`
vim.keymap.set('n', '<Home>', '^', { desc = "Aller au début de la ligne" })          -- `goto_line_start`
vim.keymap.set('n', '<End>', 'g_', { desc = "Aller à la fin de la ligne" })          -- `goto_line_end_newline`
vim.keymap.set('i', '<CR>', '<CR>', { desc = "Insérer une nouvelle ligne" })            -- `insert_newline  Enter`
--______________________________________________________________




--______________________________________________________________
-- browser de source ... et visualisation (Preview) 
--______________________________________________________________
-- Explorateur de fichiers filtré pour Rust/C/Zig (nécessite fzf-lua)
-- Installation : git clone https://github.com/ibhagwan/fzf-lua ~/.config/nvim/pack/plugins/start/fzf-lua
-- Installation pacman -S bat 

-- Configuration pour fzf-lua (layout vertical)
-- Redessine fzf-lua lors du redimensionnement de la fenêtre

-- Configuration complète de fzf-lua
require("fzf-lua").setup({
  -- Options globales pour fzf-lua
  winopts = {
    height = 1.0,            -- Hauteur totale
    width = 1.0,             -- Largeur
    row = 0.1,               -- Position verticale (10% du haut)
    col = 0.1,               -- Position horizontale (10% de la gauche)
    border = "sharp",        -- Style de bordure
    preview = {
      vertical = "down:60%", -- Aperçu en bas (60%)
      hidden = false,        -- Affiche les fichiers cachés
    },
  },
  files = {
    cmd = "fd --type f --hidden --exclude .git --exclude target '\\.(rs|sh|c|cpp)$'",
    prompt = ' Fichiers> ',
    header = "Explorer| ENTREE: ouvrir | ESC: quitter",
    previewer = "bat",
    git_icons = true,
  },
  oldfiles = {
    cmd = "fd --type f --hidden --exclude .git --exclude target '\\.(rs|sh|c|cpp)$'",
    prompt = ' Historique> ',
    header = "Historique| ENTREE: ouvrir | ESC: quitter",
    previewer = "bat",
    git_icons = true,
  },
})



--- Vérifie si une fenêtre flottante est ouverte
---@return boolean
local function is_float_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, config = pcall(vim.api.nvim_win_get_config, win)
    if ok and config.relative ~= "" then  -- "" signifie que ce n'est pas une float
      return true
    end
  end
  return false
end

-- Mapping pour <C-e> (nettoyage + ouverture)
vim.keymap.set({'n', 'v','t'}, '<C-e>', function()
	if is_float_open() then return end
  vim.cmd('only | bd!')  -- Nettoie les fenêtres/buffers

  require("fzf-lua").files()
end, { desc = "Explorateur vertical (fzf-lua)" })



vim.keymap.set({'n', 'v','t'}, '<C-f>', function()
	if is_float_open() then return end
  vim.cmd('only | bd!')  -- Nettoie les fenêtres/buffers

  require("fzf-lua").oldfiles()
end, { desc = "Explorateur vertical (fzf-lua)" })



-- Démarrage automatique (optionnel)
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  once = true,
  callback = function()
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        vim.cmd('only | bd!')
        require("fzf-lua").files()
      end, 10)
    end
  end,
})


--_____________________________________________________________________________
--_____________________________________________________________________________


-- goto ligne       ex: Ligne:235
-- attention en mode 'v' la selection vas ce faire de l'emplacement du cursor jusqu'au n° deligne choisie
-- por les mode 'n','i' goto ligne
vim.keymap.set({'n', 'i','v'}, '<C-g>', function()
  vim.ui.input({ prompt = "Ligne: ", }, function(line)
    if line and tonumber(line) then
      vim.cmd(':' .. line)
    else
      print("Saisie invalide (attendu: un numéro de ligne)")
    end
  end)
end, { desc = "Aller à la ligne" })

--______________________________________________________________
-- CLEAR
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

  vim.schedule(function()
      vim.cmd([[highlight CursorLine guibg=#262626 ctermbg=235 guifg=NONE ctermfg=NONE]])
  end)
        
        
  print("🧹 Tout purgé SAUF le buffer actuel (et # supprimé si possible)")
end, { desc = "Purge TOTALE (sauf buffer actuel)", silent = false })



--______________________________________________________________
-- sauvegarde  
vim.keymap.set({'i','n'}, '<C-s>', function() 
vim.cmd(':write!')

if vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
vim.cmd([[ execute "normal! \<ESC>" ]])

  vim.schedule(function()
		vim.cmd([[highlight NonText guifg=#5a0d0d cterm=NONE guibg=NONE]])
  end)
  
local src_name = vim.fn.expand('%:p')
log("✅ sauvegarde" .. src_name)
end, { desc = "Sauvegarder" })

--______________________________________________________________

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
--________________________________________________
-- restaure les couleurs et la syntax
--________________________________________________ 
--______________________________________________________________
-- les plugins   lspconfig et  FZF sont traité én amont
--______________________________________________________________

vim.cmd('packadd nvim-comment')

require('nvim_comment').setup()
-- Mapping pour commenter un bloc en mode visuel
vim.keymap.set({'n','v'}, '<C-t>', ':CommentToggle<CR>', { desc = "Commenter le bloc" })

-- Mapping tabulation
local ibl = require("ibl")

-- Charger nvim-web-devicons (version locale)
require('nvim-web-devicons').setup()



local function setup_ibl()
  ibl.setup({
    indent = {
      char = "",           -- Aucun caractère pour les espaces
      tab_char = "│",      -- Affiche les \t comme │
      highlight = {"IblIndentChar"},
    },
    scope = { enabled = false },
  })
end

-- Applique les couleurs et la configuration d'IBL au démarrage
setup_colors()
setup_ibl()

-- Rafraîchit les couleurs et la syntaxe au redimensionnement
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd("hi clear | syntax reset | redraw!")
    vim.opt.syntax = "off"  -- Désactive la syntaxe si besoin
    setup_colors()          -- Réapplique les couleurs
    setup_ibl()             -- Réapplique les indentations
  end,
})



--   set guicursor+=i-ci-ve:ver25
--_______________________________________
--Élément,Couleur (guifg),Description
--_______________________________________

--Comment,#af875f (orange),Commentaires dans le code.
--String,#00af00 (vert),Chaînes de caractères.
--Number,#ffaf00 (orange clair),Nombres.
--Keyword,#ff8700 (orange foncé),Mots-clés (ex: if, for).
--Function,#51afef (bleu clair),Fonctions.
--Type,#d7d700 (jaune),Types (ex: int, struct).
--Identifier,#d75fff (violet),Identifiants (noms de variables).
--Boolean,#87875f (vert foncé),Valeurs booléennes (true, false).
--Error,#ff0000 (rouge),Erreurs.
--NonText,#461613 (marron),Caractères non-textuels.
--Constant,#87af5f (vert clair),Constantes.
