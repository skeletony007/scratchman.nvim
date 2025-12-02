local M = {}

--- Create the scratch buffer. Can be from an original buffer (handle).
---@param origin_bufnr? integer
---@return integer scratch_bufnr buffer handle for scratch_bufnr
function M.create(origin_bufnr)
    local scratch_bufnr = vim.api.nvim_create_buf(false, true)

    vim.bo[scratch_bufnr].bufhidden = "wipe"
    vim.bo[scratch_bufnr].buftype = "nofile"

    if origin_bufnr and vim.api.nvim_buf_is_valid(origin_bufnr) then
        vim.api.nvim_buf_set_lines(scratch_bufnr, 0, -1, false, vim.api.nvim_buf_get_lines(origin_bufnr, 0, -1, false))
        local ft = vim.api.nvim_get_option_value("filetype", { buf = origin_bufnr })
        if ft then
            local lang = vim.treesitter.language.get_lang(ft)
            if not pcall(vim.treesitter.start, scratch_bufnr, lang) then
                vim.bo[scratch_bufnr].syntax = ft
            end
        end
    end

    return scratch_bufnr
end

--- Open the scratch buffer. Can be from an original buffer (handle).
---@param origin_bufnr? integer
---@return integer scratch_bufnr buffer handle for scratch_bufnr
function M.open(origin_bufnr)
    local scratch_bufnr = M.create(origin_bufnr)

    vim.api.nvim_set_current_buf(scratch_bufnr)

    return scratch_bufnr
end

vim.api.nvim_create_user_command("Scratch", function() M.open() end, {})
vim.api.nvim_create_user_command("ScratchFork", function() M.open(vim.api.nvim_get_current_buf()) end, {})

function M.setup(opts) end

return M
