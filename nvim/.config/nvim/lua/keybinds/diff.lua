wk = require("which-key")

wk.add(
  {
    { "<leader>d", group = "diff" },
    { "<leader>du", ":diffget 1<cr>", desc = "Get from left" },
    { "<leader>di", ":diffget 3<cr>", desc = "Get from right" },
    { "<leader>do", ":diffget 2<cr>", desc = "Get from middle" },
    { "<leader>dj", ":cp<cr>", desc = "Previous" },
    { "<leader>dk", ":cn<cr>", desc = "Next" },
    { "<leader>dq", ":cq<cr>", desc = "Quit" },
    { "<leader>dh", ":diffupdate<cr>", desc = "Update" },
  })

-- diff mode and conflict resolution functions
local function next_conflict()
  vim.fn.search('^\\(<\\{7\\}\\|=\\{7\\}\\||\\{7\\}\\|>\\{7\\}\\)', 'W')
end

local function prev_conflict()
  vim.fn.search('^\\(<\\{7\\}\\|=\\{7\\}\\||\\{7\\}\\|>\\{7\\}\\)', 'bW')
end

local function choose_ours()
  -- Delete from <<<<<<< to |||||||, then from ======= to >>>>>>>
  -- This keeps only the HEAD version
  vim.cmd([[/^<\{7\}/;/^|\{7\}/d]])
  vim.cmd([[/^=\{7\}/;/^>\{7\}/d]])
  -- Clean up remaining markers
  vim.cmd([[?^<\{7\}?d]])
  vim.cmd([[/^>\{7\}/d]])
end

local function choose_theirs()
  -- Delete from <<<<<<< to =======
  -- This keeps only the incoming version
  vim.cmd([[/^<\{7\}/;/^=\{7\}/d]])
  -- Clean up remaining marker
  vim.cmd([[/^>\{7\}/d]])
end

local function choose_base()
  -- Delete from <<<<<<< to |||||||, then from ======= to >>>>>>>
  -- This keeps only the base version
  vim.cmd([[/^<\{7\}/;/^|\{7\}/d]])
  vim.cmd([[/^=\{7\}/;/^>\{7\}/d]])
end

local function choose_both()
  -- Delete only the markers, keep both versions
  vim.cmd([[/^<\{7\}/d]])
  vim.cmd([[/^|\{7\}/;/^=\{7\}/d]])
  vim.cmd([[/^>\{7\}/d]])
end

local function choose_none()
  -- Delete the entire conflict including all versions
  vim.cmd([[/^<\{7\}/;/^>\{7\}/d]])
end

-- conflict resolution keybinds (always available)
wk.add({
  { "<leader>c", group = "conflict resolution" },
  { "<leader>cn", next_conflict, desc = "Next conflict" },
  { "<leader>cp", prev_conflict, desc = "Previous conflict" },
  { "<leader>co", choose_ours, desc = "Choose ours (HEAD)" },
  { "<leader>ct", choose_theirs, desc = "Choose theirs (incoming)" },
  { "<leader>cb", choose_base, desc = "Choose base (original)" },
  { "<leader>ca", choose_both, desc = "Choose both (keep all)" },
  { "<leader>c0", choose_none, desc = "Choose none (delete all)" },
})

-- Also add ]c and [c for quick navigation
vim.keymap.set("n", "]c", next_conflict, { noremap = true, silent = true, desc = "Next conflict" })
vim.keymap.set("n", "[c", prev_conflict, { noremap = true, silent = true, desc = "Previous conflict" })

