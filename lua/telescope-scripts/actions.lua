local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

M.close_and_source = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  vim.cmd('source ' .. selection.value)
  vim.cmd([[redraw! | echo ""]])
end

return M
