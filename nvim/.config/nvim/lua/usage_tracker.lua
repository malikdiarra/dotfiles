-- Leader shortcuts usage tracker
local M = {}

-- Configuration
local config = {
  data_file = vim.fn.stdpath('data') .. '/leader_usage.json',
  enabled = true,
}

-- In-memory cache
local usage_data = {}

-- Load existing data from file
local function load_data()
  local file = io.open(config.data_file, 'r')
  if file then
    local content = file:read('*all')
    file:close()

    local ok, data = pcall(vim.json.decode, content)
    if ok and data then
      usage_data = data
    else
      usage_data = {}
    end
  else
    usage_data = {}
  end
end

-- Save data to file
local function save_data()
  local file = io.open(config.data_file, 'w')
  if file then
    local content = vim.json.encode(usage_data)
    file:write(content)
    file:close()
    return true
  else
    print("Error: Could not write to " .. config.data_file)
    return false
  end
end

-- Track keypresses to detect leader shortcuts
local current_keys = ""
local leader_key = ","
local tracking_timeout = nil

local function on_key_press(key)
  if not config.enabled then
    return
  end

  -- Cancel existing timeout
  if tracking_timeout then
    vim.fn.timer_stop(tracking_timeout)
  end

  -- Normalize special keys
  key = vim.fn.keytrans(key)

  -- Check if this is the leader key
  if key == leader_key then
    current_keys = "<leader>"
  elseif current_keys:match("^<leader>") then
    -- Continue building the sequence
    current_keys = current_keys .. key

    -- Try to find matching keymap
    local leader = vim.g.mapleader or ","
    local actual_keys = current_keys:gsub("<leader>", leader)

    -- Check if this is a complete keymap
    local maps = vim.api.nvim_get_keymap('n')
    for _, map in ipairs(maps) do
      if map.lhs == actual_keys then
        -- Found a matching keymap! Track it
        local desc = map.desc or "No description"
        M.track(current_keys, desc)
        current_keys = ""
        return
      end
    end
  else
    current_keys = ""
  end

  -- Reset after 2 seconds of inactivity
  tracking_timeout = vim.fn.timer_start(2000, function()
    current_keys = ""
  end)
end

-- Initialize tracker
function M.setup()
  load_data()
  leader_key = vim.g.mapleader or ","

  -- Set up key tracking
  vim.on_key(on_key_press, vim.api.nvim_create_namespace("usage_tracker"))
end

-- Track a shortcut usage
function M.track(shortcut, description)
  if not config.enabled then
    return
  end

  -- Normalize the shortcut (remove <cmd>, <cr>, etc.)
  local key = shortcut:gsub('^<leader>', ','):gsub('<[^>]+>', '')

  if not usage_data[shortcut] then
    usage_data[shortcut] = {
      count = 0,
      description = description or "No description",
      first_used = os.time(),
      last_used = os.time(),
    }
  end

  usage_data[shortcut].count = usage_data[shortcut].count + 1
  usage_data[shortcut].last_used = os.time()
  usage_data[shortcut].description = description or usage_data[shortcut].description

  -- Save periodically (every 10 uses to avoid excessive I/O)
  local total = 0
  for _, data in pairs(usage_data) do
    total = total + data.count
  end

  if total % 10 == 0 then
    save_data()
  end
end

-- Get statistics
function M.get_stats()
  local stats = {}
  local total_count = 0

  -- Convert to array and calculate totals
  for shortcut, data in pairs(usage_data) do
    total_count = total_count + data.count
    table.insert(stats, {
      shortcut = shortcut,
      count = data.count,
      description = data.description,
      first_used = data.first_used,
      last_used = data.last_used,
    })
  end

  -- Sort by count (descending)
  table.sort(stats, function(a, b) return a.count > b.count end)

  -- Add percentages
  for _, stat in ipairs(stats) do
    stat.percentage = total_count > 0 and (stat.count / total_count * 100) or 0
  end

  return stats, total_count
end

-- Display statistics
function M.show_stats()
  local stats, total = M.get_stats()

  if #stats == 0 then
    print("No usage data yet. Start using leader shortcuts to track them!")
    return
  end

  -- Create a buffer for display
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  local lines = {
    "# Leader Shortcuts Usage Statistics",
    "",
    "**Total uses:** " .. total,
    "**Unique shortcuts:** " .. #stats,
    "**Data file:** " .. config.data_file,
    "",
    "---",
    "",
    "## Most Used Shortcuts",
    "",
    "| Rank | Shortcut | Count | % | Description |",
    "|------|----------|-------|---|-------------|",
  }

  -- Top 20 most used
  local top_count = math.min(20, #stats)
  for i = 1, top_count do
    local stat = stats[i]
    local percentage = string.format("%.1f%%", stat.percentage)
    table.insert(lines, string.format("| %d | `%s` | %d | %s | %s |",
      i, stat.shortcut, stat.count, percentage, stat.description))
  end

  -- Least used (if there are many shortcuts)
  if #stats > 25 then
    table.insert(lines, "")
    table.insert(lines, "## Least Used Shortcuts")
    table.insert(lines, "")
    table.insert(lines, "These shortcuts might need better positioning or could be removed:")
    table.insert(lines, "")
    table.insert(lines, "| Shortcut | Count | Description |")
    table.insert(lines, "|----------|-------|-------------|")

    for i = math.max(#stats - 9, top_count + 1), #stats do
      local stat = stats[i]
      table.insert(lines, string.format("| `%s` | %d | %s |",
        stat.shortcut, stat.count, stat.description))
    end
  end

  -- Add suggestions
  table.insert(lines, "")
  table.insert(lines, "---")
  table.insert(lines, "")
  table.insert(lines, "## Commands")
  table.insert(lines, "")
  table.insert(lines, "- `:LeaderStatsExport csv` - Export to CSV")
  table.insert(lines, "- `:LeaderStatsExport json` - Export to JSON")
  table.insert(lines, "- `:LeaderStatsClear` - Clear all usage data")
  table.insert(lines, "- `:LeaderStatsDisable` - Temporarily disable tracking")
  table.insert(lines, "- `:LeaderStatsEnable` - Re-enable tracking")
  table.insert(lines, "")

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Open in a split
  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, buf)
end

-- Export data
function M.export(format)
  format = format or 'csv'
  local stats, total = M.get_stats()

  if #stats == 0 then
    print("No data to export")
    return
  end

  local filename = vim.fn.stdpath('config') .. '/leader_usage.' .. format
  local file = io.open(filename, 'w')

  if not file then
    print("Error: Could not write to " .. filename)
    return
  end

  if format == 'csv' then
    -- CSV export
    file:write("Shortcut,Count,Percentage,Description,First Used,Last Used\n")
    for _, stat in ipairs(stats) do
      local first_used = os.date("%Y-%m-%d %H:%M:%S", stat.first_used)
      local last_used = os.date("%Y-%m-%d %H:%M:%S", stat.last_used)
      file:write(string.format('"%s",%d,%.2f,"%s","%s","%s"\n',
        stat.shortcut, stat.count, stat.percentage,
        stat.description:gsub('"', '""'), first_used, last_used))
    end
  elseif format == 'json' then
    -- JSON export (with metadata)
    local export_data = {
      generated = os.date("%Y-%m-%d %H:%M:%S"),
      total_uses = total,
      unique_shortcuts = #stats,
      shortcuts = stats
    }
    file:write(vim.json.encode(export_data))
  end

  file:close()
  print("Usage data exported to: " .. filename)
end

-- Clear all data
function M.clear()
  usage_data = {}
  save_data()
  print("Usage data cleared")
end

-- Enable/disable tracking
function M.enable()
  config.enabled = true
  print("Usage tracking enabled")
end

function M.disable()
  config.enabled = false
  save_data()  -- Save before disabling
  print("Usage tracking disabled")
end

-- Wrap a function to track its usage
function M.wrap_function(shortcut, description, func)
  return function()
    M.track(shortcut, description)
    return func()
  end
end

-- Cleanup on exit
function M.cleanup()
  save_data()
end

return M
