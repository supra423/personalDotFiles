return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			{
				"mfussenegger/nvim-dap-python",
				config = function()
					require("dap-python").setup("python3")
				end,
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = "/home/supra/.local/share/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
			}
			dap.configurations.rust = {
				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input(
							"Path to executable (Input project name at the end): ",
							vim.fn.getcwd() .. "/target/debug/",
							"file"
						)
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = false,
				},
			}
			-- dap.adapters.gdb = {
			--   type = 'executable',
			--   command = 'gdb',
			--   args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
			-- }
			-- dap.configurations.c = {
			--   {
			--     name = 'Launch file',
			--     type = 'gdb',
			--     request = 'launch',
			--     program = function()
			--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			--     end,
			--     cwd = '${workspaceFolder}',
			--     stopOnEntry = false,
			--   },
			-- }
			-- dap.configurations.cpp = dap.configurations.c
			--
			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue debugging" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
		end,
	},
}
