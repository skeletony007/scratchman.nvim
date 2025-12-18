local M = {}

--- Creates a new scratch buffer. Can be a new buffer or "forked" from a
--- given buffer.
---@param origin_buf? integer Buffer to fork from
---@return integer scratch_buf Buffer id for scratch_buf, or 0 on error
function M.create_scratch_buf(origin_buf)
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    if scratch_buf == 0 then
        return 0
    end

    vim.bo[scratch_buf].bufhidden = "wipe"
    vim.bo[scratch_buf].buftype = "nofile"

    if origin_buf and vim.api.nvim_buf_is_valid(origin_buf) then
        vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, vim.api.nvim_buf_get_lines(origin_buf, 0, -1, false))
        local ft = vim.api.nvim_get_option_value("filetype", { buf = origin_buf })
        if ft then
            local lang = vim.treesitter.language.get_lang(ft)
            if not pcall(vim.treesitter.start, scratch_buf, lang) then
                vim.bo[scratch_buf].syntax = ft
            end
        end
    end

    return scratch_buf
end

vim.api.nvim_create_user_command("Scratch", function() vim.api.nvim_set_current_buf(M.create_scratch_buf()) end, {})
vim.api.nvim_create_user_command("ScratchFork", function()
    local origin = { view = vim.fn.winsaveview() }
    vim.api.nvim_set_current_buf(M.create_scratch_buf(vim.api.nvim_get_current_buf()))
    vim.fn.winrestview(origin.view)
end, {})

function M.setup(opts) end

return M
