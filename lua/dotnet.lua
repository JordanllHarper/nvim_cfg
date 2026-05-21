local M = {
    run = {
        cmd = "dotnet run",
        project = nil,
        env_variables = {}
    },
    test_cmd = "dotnet test",
    secrets_cmd = "dotnet user-secrets --list",
}

local win = nil
local buf = nil
local curr_id = nil

function M.setup(opts)
    if opts.run then
        if opts.run.cmd then M.run.cmd = opts.run.cmd end
        if opts.run.project then M.run.project = opts.run.project end
        if opts.run.env_variables then M.run.env_variables = opts.run.env_variables end
    end
    if opts.test_cmd then M.test_cmd = opts.test_cmd end
    if opts.secrets_cmd then M.secrets_cmd = opts.secrets_cmd end
end

local function stop_and_start_cmd(cmd)
    if curr_id then
        vim.fn.jobstop(curr_id)
        curr_id = nil
    end
    local append_contents = function(_, data)
        if data and type(data) == "table" then
            if not buf or not vim.api.nvim_buf_is_loaded(buf) then
                buf = vim.api.nvim_create_buf(true, true)
                vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "Output:" })
                vim.api.nvim_buf_set_lines(buf, 1, 1, false, { "=======" })
            end
            vim.api.nvim_buf_set_lines(
                buf,
                -1,
                -1,
                false,
                data
            )
            local line_count = vim.api.nvim_buf_line_count(buf)
            if not win or not vim.api.nvim_win_is_valid(win) then
                win = vim.api.nvim_open_win(
                    buf,
                    false,
                    {
                        split = 'right',
                        win = 0
                    }
                )
            end
            vim.api.nvim_win_set_cursor(win, { line_count, 0 })
        end
    end
    curr_id = vim.fn.jobstart(
        cmd,
        {
            on_stdout = append_contents,
            on_stderr = append_contents,
            on_exit = append_contents,
            stderr_buffered = true,
        }
    )
end

function M.start()
    if not M.run then
        print("No run configuration set")
        return
    end
    local run_cmd = M.run.cmd
    if not run_cmd then
        print("No run command set")
        return
    end
    if M.run.project then
        run_cmd = string.format("%s --project %s", run_cmd, M.run.project)
    end
    local variables = M.run.env_variables
    if variables then
        for key, value in pairs(variables) do
            run_cmd = string.format("%s -e %s=%s", run_cmd, key, value)
        end
    end

    stop_and_start_cmd(run_cmd)
end

function M.stop()
    if curr_id then
        vim.fn.jobstop(curr_id)
        curr_id = nil
    else
        print("No running job...")
    end
end

function M.clean_buffer()
    if not buf or not vim.api.nvim_buf_is_loaded(buf) then
        print("No buffer")
        return
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
end

function M.test()
    stop_and_start_cmd(M.test_cmd)
end

function M.user_secrets()
    stop_and_start_cmd(M.secrets_cmd)
end

return M
