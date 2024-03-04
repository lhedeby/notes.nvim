# Notes.nvim

**notes.nvim** is a simple note taking plugin for Neovim

## Installation

Use your prefered plugin manager

### lazy.nvim

```lua
{ 
    'notes.nvim',
    opts = {} -- optional, use if you want to change the default settings
}
```

## Usage

Map a key to the `open` function

```lua
vim.keymap.set('n', '<leader>n', require 'notes'.open, { desc = '[N]otes' })
```

## Configuration

defaults:  

```lua
{
    path = vim.fn.stdpath "data" .. "/" .. "notes-nvim/", -- Path to the folder where all notes should be stored 
    height = 40, -- height of both windows
    list_width = 20, -- width of the list
    note_width = 40, -- width of the currently selected note
    row = 5, -- window row offset
    col = 15, -- window col offset
    file_extension = ".md", -- extension added to notes
    new_note_text = "<New note>", -- New note option text
}
```

## Upcoming
- Tags
- Filters
- Search
- More sensible keybindings
