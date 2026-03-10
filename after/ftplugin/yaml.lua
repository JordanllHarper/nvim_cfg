require 'blink.indent'.enable(true, {
    bufnr = 0
})

local specWatcherId = nil

require 'utils'.leader_nmap(
    "RS",
    function()
        local function printOutput(_, data)
            if data then
                if data[1] == "" then
                    print("Stopped")
                    return
                end
                print(data[1])
            end
        end
        if specWatcherId then
            vim.fn.jobstop(specWatcherId)
            specWatcherId = nil
            print("Stopped")
            return
        end
        specWatcherId = vim.fn.jobstart(
            { "swagger-ui-watcher", vim.fn.expand("%") },
            {
                on_stdout = printOutput,
                on_sterr = function(_, data)
                    printOutput(_, data)
                    specWatcherId = nil
                end
            }
        )
    end,
    "[R]un [S]pec watcher (toggle)",
    0
)
