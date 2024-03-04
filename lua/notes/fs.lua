local Config = require "notes.config"
local Util = require "notes.util"
local uv = vim.loop

local M = {}

function M.save_note(notes, override)
    local content = vim.api.nvim_buf_get_lines(notes.bufs.note, 0, -1, true)
    local flag = override and "w" or "wx"
    local fd = uv.fs_open(Config.options.path .. notes.curr_note .. Config.options.file_extension, flag, 438)
    if fd ~= nil then
        for _, line in ipairs(content) do
            uv.fs_write(fd, line .. '\n', -1)
        end
        uv.fs_close(fd)
        return 0
    else
        Util.Error("Error saving file")
        return 1
    end
end

function M.rename_note(name, new_name)
    local result = uv.fs_rename(
        Config.options.path .. name .. Config.options.file_extension,
        Config.options.path .. new_name .. Config.options.file_extension
    )
    if result ~= true then
        Util.Error("Error renaming file")
    end
end

function M.load_note_list()
    local file_list = vim.fn.readdir(Config.options.path)
    local l = {}
    for k, v in pairs(file_list) do
        l[k] = string.sub(v, 1, -1 - #Config.options.file_extension)
    end
    return l
end

function M.delete_file(name)
    local success = uv.fs_unlink(Config.options.path .. name .. Config.options.file_extension)
    if success == nil then
        Util.Error("Error deleting file")
    end
end

return M
