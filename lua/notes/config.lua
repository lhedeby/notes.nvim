local M = {}

local defaults = {
    path = vim.fn.stdpath "data" .. "/" .. "notes-nvim/", -- Path to the folder where all notes should be stored 
    height = 40, -- height of both windows
    list_width = 20, -- width of the list
    note_width = 40, -- width of the currently selected note
    row = 5, -- window row offset
    col = 15, -- window col offset
    file_extension = ".md", -- extension added to notes
    new_note_text = "<New note>", -- New note option text
}

M.options = {}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", defaults, opts)
    vim.fn.mkdir(M.options.path, "p")
end

return M
