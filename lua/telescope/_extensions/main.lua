local scripts = function()
  local telescope_undo = require("telescope-scripts")
  telescope_scripts.scripts()
end

return telescope.register_extension({
  exports = {
    scrripts = scripts,
  },
})
