local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local Path = require("plenary.path")
local scandir = require("plenary.scandir")

local M = {}

local function list_subdirs(dir)
  return scandir.scan_dir(dir, { only_dirs = true, depth = 1 })
end

local function list_files_in(dir)
  return scandir.scan_dir(dir, { only_dirs = false, depth = 1 })
end

local function list_valid_stages_with_doc(data_dir, doc)
  local doc_repo_dir = Path:new(data_dir, "primary", "doc-repo")
  local stages = list_subdirs(doc_repo_dir:absolute())
  local valid = {}

  for _, stage_path in ipairs(stages) do
    local stage_name = Path:new(stage_path):make_relative(doc_repo_dir:absolute())
    local doc_path = Path:new(stage_path, doc)
    if doc_path:exists() and doc_path:is_dir() then
      table.insert(valid, stage_name)
    end
  end

  return valid
end

local function open_file_readonly(filepath)
  local ext = filepath:match("^.+(%..+)$") or ""

  if ext == ".jsonl" then
    -- Open a new scratch buffer and pretty-print using jq
    local output = vim.fn.systemlist({ "jq", ".", filepath })
    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to format jsonl with jq", vim.log.levels.ERROR)
      return
    end

    vim.cmd("enew")  -- New scratch buffer
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
    vim.bo.filetype = "json"
    vim.bo.modified = false
    vim.bo.readonly = true
    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
    vim.bo.modified = false
  else
    vim.cmd("edit " .. filepath)
    vim.bo.readonly = true
  end
end

function M.doc_stage_picker()
  local data_dir = vim.fn.getenv("DATA_DIR")
  if not data_dir or data_dir == "" then
    vim.notify("DATA_DIR not set", vim.log.levels.ERROR)
    return
  end

  local original_dir = Path:new(data_dir, "primary", "doc-repo", "original"):absolute()
  local doc_folders = list_subdirs(original_dir)
  local doc_names = vim.tbl_map(function(path)
    return Path:new(path):make_relative(original_dir)
  end, doc_folders)

  -- Picker 1: Select document
  pickers.new({}, {
    prompt_title = "Select Document",
    finder = finders.new_table({ results = doc_names }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(buf)
        actions.close(buf)
        local doc = action_state.get_selected_entry().value

        -- Filter valid stages
        local valid_stages = list_valid_stages_with_doc(data_dir, doc)
        if #valid_stages == 0 then
          vim.notify("No stages found for document: " .. doc, vim.log.levels.WARN)
          return
        end

        -- Picker 2: Select stage
        pickers.new({}, {
          prompt_title = "Select Stage",
          finder = finders.new_table({ results = valid_stages }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(_, map2)
            actions.select_default:replace(function(buf2)
              actions.close(buf2)
              local stage = action_state.get_selected_entry().value
              local doc_path = Path:new(data_dir, "primary", "doc-repo", stage, doc):absolute()
              local files = list_files_in(doc_path)

              if #files == 0 then
                vim.notify("No files found in " .. doc_path, vim.log.levels.WARN)
                return
              elseif #files == 1 then
                open_file_readonly(files[1])
              else
                -- Picker 3: Select file
                pickers.new({}, {
                  prompt_title = string.format("Files in %s/%s", stage, doc),
                  finder = finders.new_table({
                    results = files,
                    entry_maker = function(entry)
                      return {
                        value = entry,
                        display = Path:new(entry):make_relative(doc_path),
                        ordinal = entry,
                      }
                    end,
                  }),
                  sorter = conf.generic_sorter({}),
                  attach_mappings = function(_, map3)
                    actions.select_default:replace(function(buf3)
                      actions.close(buf3)
                      local file = action_state.get_selected_entry().value
                      open_file_readonly(file)
                    end)
                    return true
                  end,
                }):find()
              end
            end)
            return true
          end,
        }):find()
      end)
      return true
    end,
  }):find()
end

return M
