-- Module for generating leader shortcuts documentation
local M = {}

-- Helper function to get all keymaps
local function get_leader_keymaps()
  local leader = vim.g.mapleader or ","
  local keymaps = {}

  -- Get all normal mode keymaps that start with leader
  local all_keymaps = vim.api.nvim_get_keymap('n')

  for _, map in ipairs(all_keymaps) do
    if map.lhs and map.lhs:match("^" .. vim.pesc(leader)) then
      table.insert(keymaps, {
        lhs = map.lhs,
        rhs = map.rhs or "",
        desc = map.desc or "No description",
      })
    end
  end

  -- Sort by lhs
  table.sort(keymaps, function(a, b) return a.lhs < b.lhs end)

  return keymaps, leader
end

-- Helper function to organize keymaps by group
local function organize_by_group(keymaps, leader)
  local groups = {}
  local standalone = {}

  for _, map in ipairs(keymaps) do
    -- Remove leader prefix for cleaner display
    local key = map.lhs:gsub("^" .. vim.pesc(leader), "<leader>")

    -- Check if this is a group key (just leader + one char)
    if #key == 9 then  -- length of "<leader>X"
      local group_char = key:sub(9, 9)
      if not groups[group_char] then
        groups[group_char] = {
          name = map.desc or "Unknown group",
          keys = {}
        }
      end
    else
      -- This is a subkey, find its group
      local group_char = key:sub(9, 9)
      if groups[group_char] then
        table.insert(groups[group_char].keys, {
          key = key,
          desc = map.desc,
          rhs = map.rhs
        })
      else
        -- Standalone key
        table.insert(standalone, {
          key = key,
          desc = map.desc,
          rhs = map.rhs
        })
      end
    end
  end

  return groups, standalone
end

-- Generate markdown documentation
function M.generate_markdown()
  local keymaps, leader = get_leader_keymaps()

  if #keymaps == 0 then
    return "No leader keymaps found."
  end

  local lines = {
    "# Neovim Leader Shortcuts",
    "",
    "Leader key: `" .. leader .. "`",
    "",
    "Generated: " .. os.date("%Y-%m-%d %H:%M:%S"),
    "",
    "---",
    "",
  }

  local groups, standalone = organize_by_group(keymaps, leader)

  -- Sort group keys alphabetically
  local group_keys = {}
  for k in pairs(groups) do
    table.insert(group_keys, k)
  end
  table.sort(group_keys)

  -- Add grouped shortcuts
  for _, group_key in ipairs(group_keys) do
    local group = groups[group_key]
    table.insert(lines, "## `<leader>" .. group_key .. "*` - " .. group.name)
    table.insert(lines, "")

    if #group.keys > 0 then
      table.insert(lines, "| Shortcut | Description |")
      table.insert(lines, "|----------|-------------|")

      -- Sort keys within group
      table.sort(group.keys, function(a, b) return a.key < b.key end)

      for _, key in ipairs(group.keys) do
        table.insert(lines, "| `" .. key.key .. "` | " .. key.desc .. " |")
      end
    else
      table.insert(lines, "*Group prefix - press to see available commands*")
    end

    table.insert(lines, "")
  end

  -- Add standalone shortcuts
  if #standalone > 0 then
    table.insert(lines, "## Standalone Shortcuts")
    table.insert(lines, "")
    table.insert(lines, "| Shortcut | Description |")
    table.insert(lines, "|----------|-------------|")

    table.sort(standalone, function(a, b) return a.key < b.key end)

    for _, key in ipairs(standalone) do
      table.insert(lines, "| `" .. key.key .. "` | " .. key.desc .. " |")
    end

    table.insert(lines, "")
  end

  -- Add tips section
  table.insert(lines, "---")
  table.insert(lines, "")
  table.insert(lines, "## Tips")
  table.insert(lines, "")
  table.insert(lines, "- Press `" .. leader .. "` to see all available shortcuts (via which-key)")
  table.insert(lines, "- Use `<leader>fk` to search keymaps with Telescope")
  table.insert(lines, "- Use `:WhichKey " .. leader .. "` to see leader shortcuts in a popup")
  table.insert(lines, "- Use `:LeaderShortcuts` to regenerate this documentation")
  table.insert(lines, "")

  return table.concat(lines, "\n")
end

-- Save markdown to file
function M.save_to_file(filename)
  filename = filename or vim.fn.stdpath('config') .. '/LEADER_SHORTCUTS.md'

  local content = M.generate_markdown()

  local file = io.open(filename, 'w')
  if file then
    file:write(content)
    file:close()
    print("Leader shortcuts saved to: " .. filename)
    return true
  else
    print("Error: Could not write to " .. filename)
    return false
  end
end

-- Open the documentation in a split
function M.open_docs()
  local filename = vim.fn.stdpath('config') .. '/LEADER_SHORTCUTS.md'

  -- Generate/update the file first
  M.save_to_file(filename)

  -- Open in a vertical split
  vim.cmd('vsplit ' .. filename)
end

return M
