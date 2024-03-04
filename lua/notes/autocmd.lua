local Config = require "notes.config"
local Fs = require "notes.fs"

local M = {}

local GroupName = "NotesAutoCmds"

local function close(notes)
    vim.api.nvim_win_close(notes.wins.note, true)
    vim.api.nvim_win_close(notes.wins.list, true)
    vim.api.nvim_del_augroup_by_name(GroupName)
    notes.open = false
end

local function close_both(notes)
    vim.api.nvim_create_autocmd("WinClosed", {
        group = GroupName,
        buffer = notes.bufs.list,
        callback = function(_)
            close(notes)
            return true
        end,
    })

    vim.api.nvim_create_autocmd("WinClosed", {
        group = GroupName,
        buffer = notes.bufs.note,
        callback = function(_)
            close(notes)
            return true
        end,
    })
end

local function close_on_leave(notes)
    vim.api.nvim_create_autocmd("WinEnter", {
        group = GroupName,
        callback = function(_)
            local curr_win = vim.api.nvim_get_current_win()
            if curr_win ~= notes.wins.note and curr_win ~= notes.wins.list then
                close(notes)
                return true
            end
        end
    })
end

local function buf_leave(notes)
    vim.api.nvim_create_autocmd("BufLeave", {
        group = GroupName,
        buffer = notes.bufs.note,
        callback = function(_)
            if notes.curr_note ~= Config.options.new_note_text then
                Fs.save_note(notes, true)
            end
        end,
    })
end

local function cursor_moved(notes)
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = GroupName,
        buffer = notes.bufs.list,
        callback = function(_)
            local note_name = vim.api.nvim_get_current_line()
            notes.curr_note = note_name
            if note_name == Config.options.new_note_text then
                vim.api.nvim_buf_set_lines(notes.bufs.note, 0, -1, false, {})
                vim.api.nvim_win_set_config(notes.wins.note, { title = " " .. note_name .. " " })
            elseif note_name ~= nil and #note_name ~= 0 then
                local path = Config.options.path .. note_name .. Config.options.file_extension
                vim.api.nvim_buf_set_lines(notes.bufs.note, 0, -1, false, vim.fn.readfile(path))
                vim.api.nvim_win_set_config(notes.wins.note, { title = " " .. note_name .. " " })
            end
        end,
    })
end

local function exit_when_buf_is_replaced(notes)
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = GroupName,
        callback = function(_)
            close(notes)
        end
    })
end

function M.set(notes)
    vim.api.nvim_create_augroup(GroupName, {})
    close_both(notes)
    buf_leave(notes)
    cursor_moved(notes)
    close_on_leave(notes)
    exit_when_buf_is_replaced(notes)
end

return M
