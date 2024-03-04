local Config = require "notes.config"
local Keymaps = require "notes.keymaps"
local Autocmd = require "notes.autocmd"
local Fs = require "notes.fs"

local M = {}

local notes = {
    bufs = {},
    wins = {},
    curr_note = nil,
    open = false,
}

local function get_shared_win_config()
    return {
        relative = 'editor',
        height = Config.options.height,
        row = Config.options.row,
        style = 'minimal',
        border = 'rounded',
        title = ' Notes ',
        title_pos = 'center',
    }
end

function M.setup(opts)
    Config.setup(opts)
end

local function create_note_window()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    local win_config = get_shared_win_config()
    win_config.col = Config.options.col + Config.options.list_width + 2
    win_config.width = Config.options.note_width
    local win = vim.api.nvim_open_win(buf, true, win_config)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    return buf, win
end

local function create_list_window()
    local buf = vim.api.nvim_create_buf(false, true)
    local win_config = get_shared_win_config()
    win_config.width = Config.options.list_width
    win_config.title = ' Notes '
    win_config.col = Config.options.col
    local win = vim.api.nvim_open_win(buf, true, win_config)
    local note_list = Fs.load_note_list()
    table.insert(note_list, Config.options.new_note_text)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, note_list)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    return buf, win
end

function M.open()
    if notes.open then
        vim.api.nvim_set_current_win(notes.wins.list)
        return
    end
    notes.open = true
    local n_buf, n_win = create_note_window()
    local l_buf, l_win = create_list_window()
    notes.bufs = {
        note = n_buf,
        list = l_buf,
    }
    notes.wins = {
        note = n_win,
        list = l_win,
    }
    Autocmd.set(notes)
    Keymaps.set(notes, Config.options)
end

return M
