local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local vim_script_actions = require('telescope-scripts.actions') -- Include your actions file

local M = {}

M.find_vim_scripts = function()
  local files = {}
  local vim_scripts_dir = '~/.dotfiles/vim-scripts' -- Updated path

  for line in io.popen('find ' .. vim_scripts_dir .. ' -type f -name "*.vim"'):lines() do
    table.insert(files, line)
  end

  local script_entries = {}
  for _, file_path in ipairs(files) do
    local file_name = file_path:match("^.+/(.+)$")
    table.insert(script_entries, { value = file_path, display = file_name, ordinal = file_name })
  end

  pickers.new({}, {
    prompt_title = 'Vim Script Picker',
    finder = finders.new_table({
      results = script_entries,
      entry_maker = function(entry)
        return entry
      end,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(vim_script_actions.close_and_source)

      return true
    end,
  }):find()
end

return M
