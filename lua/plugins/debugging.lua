vim.pack.add({
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
})

local dap, dapui = require("dap"), require("dapui")

-- Plain Unicode instead of Nerd Font icons
dapui.setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
	controls = {
		icons = {
			pause = "⏸",
			play = "⏵",
			step_into = "↓",
			step_over = "↷",
			step_out = "↑",
			step_back = "↶",
			run_last = "↻",
			terminate = "■",
			disconnect = "⏏",
		},
	},
})

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-dap-19",
	name = "lldb",
}

dap.configurations.rust = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
		initCommands = function()
			local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
			assert(
				vim.v.shell_error == 0,
				"failed to get rust sysroot using `rustc --print sysroot`: " .. rustc_sysroot
			)
			local script_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
			local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

			return {
				([[!command script import '%s']]):format(script_file),
				([[command source '%s']]):format(commands_file),
			}
		end,
		env = function()
			local variables = {}
			for k, v in pairs(vim.fn.environ()) do
				table.insert(variables, string.format("%s=%s", k, v))
			end
			return variables
		end,
	},
}

vim.keymap.set("n", "<Leader>b", function()
	dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end)
