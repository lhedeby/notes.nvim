local Fs = require "notes.fs"
local M = {}

local function nmap(buf, key, callback)
    vim.api.nvim_buf_set_keymap(buf, "n", key, "", {
        callback = callback
    })
end

function M.set(notes, opts)
    nmap(notes.bufs.list, "l", function()
        vim.api.nvim_set_current_win(notes.wins.note)
    end)

    nmap(notes.bufs.note, "h", function()
        local cursor = vim.api.nvim_win_get_cursor(notes.wins.note)
        if cursor[2] == 0 then
            vim.api.nvim_set_current_win(notes.wins.list)
        else
            vim.api.nvim_feedkeys('h', 'n', true)
        end
    end)

    -- [R]ename
    nmap(notes.bufs.list, "r", function()
        local new_name = vim.fn.input("Enter new name for note: ")
        Fs.rename_note(notes.curr_note, new_name)
        vim.api.nvim_buf_set_option(notes.bufs.list, 'modifiable', true)
        local pos = vim.api.nvim_win_get_cursor(notes.wins.list)
        vim.api.nvim_buf_set_lines(notes.bufs.list, pos[1] - 1, pos[1], false, { new_name })
        vim.api.nvim_buf_set_option(notes.bufs.list, 'modifiable', false)
    end)

    -- [Enter] go to note/new note
    nmap(notes.bufs.list, "<CR>", function()
        if notes.curr_note == opts.new_note_text then
            local new_name = vim.fn.input("Enter name for new note: ")
            notes.curr_note = new_name
            local res = Fs.save_note(notes, false)
            if res == 0 then
                vim.api.nvim_buf_set_option(notes.bufs.list, 'modifiable', true)
                local pos = vim.api.nvim_win_get_cursor(notes.wins.list)
                vim.api.nvim_buf_set_lines(notes.bufs.list, pos[1] - 1, pos[1], false, { new_name })
                vim.api.nvim_buf_set_lines(notes.bufs.list, pos[1], pos[1] + 1, false, { opts.new_note_text })
                vim.api.nvim_buf_set_option(notes.bufs.list, 'modifiable', false)
                vim.api.nvim_win_set_config(notes.wins.note, { title = " " .. new_name .. " " })
            end
        end
        vim.api.nvim_set_current_win(notes.wins.note)
    end)

    -- [Q] exit
    nmap(notes.bufs.list, "q", function()
        vim.api.nvim_win_close(notes.wins.list, false)
    end)

    nmap(notes.bufs.list, "d", function()
        Fs.delete_file(notes.curr_note)
        vim.api.nvim_buf_set_option(notes.bufs.list, 'modifiable', true)
        vim.api.nvim_del_current_line()
        vim.api.nvim_buf_set_option(notes.bufs.list, 'modifiable', false)
    end)
end

return M
