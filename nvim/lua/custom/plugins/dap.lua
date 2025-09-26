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
				command = "/home/supra/.local/share/nvim/mason/bin/OpenDebugAD7",
			}
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}
			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb",
			}
			dap.configurations.rust = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input(
							"Path to executable (Input project name at the end): ",
							vim.fn.getcwd() .. "/target/debug/",
							"file"
						)
					end,
					cwd = "${workspaceFolder}",
					-- stopAtEntry = false,
					stopAtBeginningOfMainSubprogram = false,
					args = {},
					initCommands = function()
						local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
						local script_import = 'command script import "'
							.. rustc_sysroot
							.. '/lib/rustlib/etc/lldb_lookup.py"'
						local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

						local commands = {}
						local file = io.open(commands_file, "r")
						if file then
							for line in file:lines() do
								table.insert(commands, line)
							end
							file:close()
						end
						table.insert(commands, 1, script_import)
						return commands
					end,
				},
				-- {
				-- 	name = "Select and attach to process",
				-- 	type = "gdb",
				-- 	request = "attach",
				-- 	program = function()
				-- 		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				-- 	end,
				-- 	pid = function()
				-- 		local name = vim.fn.input("Executable name (filter): ")
				-- 		return require("dap.utils").pick_process({ filter = name })
				-- 	end,
				-- 	cwd = "${workspaceFolder}",
				-- },
				-- {
				-- 	name = "Attach to gdbserver :1234",
				-- 	type = "gdb",
				-- 	request = "attach",
				-- 	target = "localhost:1234",
				-- 	program = function()
				-- 		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				-- 	end,
				-- 	cwd = "${workspaceFolder}",
				-- },
			}
			-- dap.configurations.c = {
			-- 	{
			-- 		name = "Launch file",
			-- 		type = "gdb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 		stopOnEntry = false,
			-- 	},
			-- }
			dap.configurations.cpp = dap.configurations.rust
			-- --
			dap.configurations.c = dap.configurations.rust
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

			-- vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue debugging" })
			-- vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			-- vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			-- vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
			-- vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Step Out" })
			-- vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Terminate" })
		end,
	},
}
