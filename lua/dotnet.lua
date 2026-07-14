local M = {
    run = {
        cmd = "dotnet run",
        project = nil,
        env_variables = {}
    },
    secrets_set_cmd = {
        cmd = "dotnet user-secrets set",
        project = nil,
    },
    test_cmd = "dotnet test",
    secrets_list_cmd = "dotnet user-secrets --list",
    keymaps = {
        run = "<leader>Rp",
        test = "<leader>Rt",
        stop = "<leader>Rs",
        clean_buffer = "<leader>Rc"
    },
}

local win = nil
local buf = nil
local pid = nil

local function modify(action)
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    action()
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

local function set_keymaps(keymaps)
    local set = function(keymap, action, desc)
        vim.keymap.set("n", keymap, action,
            { silent = true, desc = desc, noremap = true })
    end
    set(keymaps and keymaps.run or M.keymaps.run, M.start, "Run project")
    set(keymaps and keymaps.test or M.keymaps.test, M.test, "Run test")
    set(keymaps and keymaps.stop or M.keymaps.stop, M.stop, "Stop project")
    set(keymaps and keymaps.clean_buffer or M.keymaps.clean_buffer, M.clean_buffer, "Clean buffer")
end

function M.setup(opts)
    if opts then
        if opts.run then
            if opts.run.cmd then M.run.cmd = opts.run.cmd end
            if opts.run.project then M.run.project = opts.run.project end
            if opts.run.env_variables then M.run.env_variables = opts.run.env_variables end
        end
        if opts.test_cmd then M.test_cmd = opts.test_cmd end
        if opts.secrets_cmd then M.secrets_set_cmd = opts.secrets_cmd end
    end
    set_keymaps(opts.keymaps)
end

local function append_contents(_, data)
    if not data or type(data) ~= "table" then return end

    if not buf or not vim.api.nvim_buf_is_loaded(buf) then
        buf = vim.api.nvim_create_buf(true, true)
        modify(
            function()
                vim.api.nvim_buf_set_lines(buf, 0, 0, false, { "Output:" })
                vim.api.nvim_buf_set_lines(buf, 1, 1, false, { "=======" })
            end
        )
    end
    if not win or not vim.api.nvim_win_is_valid(win) then
        win = vim.api.nvim_open_win(
            buf,
            false,
            {
                split = 'below',
                win = -1
            }
        )
    end
    local before_row_count = vim.api.nvim_buf_line_count(buf)
    local current_cursor_pos = vim.api.nvim_win_get_cursor(win)
    local should_scroll = current_cursor_pos[1] == before_row_count
    modify(
        function()
            vim.api.nvim_buf_set_lines(
                buf,
                -1,
                -1,
                false,
                data
            )
        end
    )
    local new_row_count = vim.api.nvim_buf_line_count(buf)
    if should_scroll then vim.api.nvim_win_set_cursor(win, { new_row_count, 0 }) end
end

local function stop_and_start_cmd(cmd)
    if pid then
        vim.fn.jobstop(pid)
        pid = nil
    end

    M.clean_buffer()

    pid = vim.fn.jobstart(
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
    if pid then
        vim.fn.jobstop(pid)
        pid = nil
    else
        print("No running job...")
    end
end

function M.clean_buffer()
    if not buf or not vim.api.nvim_buf_is_loaded(buf) then return end
    modify(
        function()
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
        end
    )
end

function M.test()
    stop_and_start_cmd(M.test_cmd)
end

function M.user_secrets_set()
    vim.ui.input({ prompt = "Enter key value for secrets: " }, function(input)
        local cmd = string.format("%s --project %s %s", M.secrets_set_cmd.cmd, M.secrets_set_cmd.project, input)
        stop_and_start_cmd(cmd)
    end)
end

function M.user_secrets()
    stop_and_start_cmd(M.secrets_list_cmd)
end

return M
