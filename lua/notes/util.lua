local M = {}

function M.Error(msg)
    vim.notify(msg, vim.log.levels.ERROR, { title = "notes.nvim" })
end

return M
