local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

M.find_vim_scripts = function()
  local files = {}
  local vim_scripts_dir = "~/.dotfiles/vim-scripts" -- Updated path

  -- Traverse the directory and add scripts to the files table
  for line in io.popen("find " .. vim_scripts_dir .. ' -type f -name "*.vim"'):lines() do
    table.insert(files, line)
  end

  pickers
    .new({}, {
      prompt_title = "Vim Script Picker",
      finder = finders.new_table {
        results = files,
        entry_maker = function(line)
          local file_name = line:match "^.+/(.+)$" -- Extract basename using pattern match
          return {
            value = line,
            display = file_name, -- Display only the basename
            ordinal = file_name,
          }
        end,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd("source " .. selection.value)
          vim.cmd [[redraw! | echo ""]]
        end)

        return true
      end,
    })
    :find()
end

return M
