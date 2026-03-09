local leader_nmap_cmd = require("utils").leader_nmap_cmd

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
    config = function(_, opts)
        local tt = require 'toggleterm'
        tt.setup(opts)

        leader_nmap_cmd("tt", "ToggleTerm", "[t]oggle [t]terminal 1")
        leader_nmap_cmd("t2", "ToggleTerm2", "[t]oggle [2]nd terminal")
    end
}
