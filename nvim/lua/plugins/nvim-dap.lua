return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")

		-- Dap Virtual Text
		dap_virtual_text.setup()

		mason_dap.setup({
			ensure_installed = { "python" },
			automatic_installation = true,
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		-- Configurations
		dap.configurations = {
			python = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch file",

					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						local cwd = vim.fn.getcwd()
						local venv_path = vim.fn.system("poetry env info -p"):match("(%S+)")

						if venv_path and venv_path ~= "" then
							return venv_path .. "/bin/python"
						end
						return "/usr/bin/python"

						-- if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
						-- 	return cwd .. "/venv/bin/python"
						-- elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
						-- 	return cwd .. "/.venv/bin/python"
						-- else
						-- 	return "/usr/bin/python"
						-- end
					end,
				},
			},
		}

		-- Dap UI

		ui.setup()

		vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end

		-- Keymaps

		local opts = { noremap = true, silent = true }

		-- Toggle breakpoint
		vim.keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, opts)

		-- Continue / Start
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, opts)

		-- Step Over
		vim.keymap.set("n", "<leader>do", function()
			dap.step_over()
		end, opts)

		-- Step Into
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, opts)

		-- Step Out
		vim.keymap.set("n", "<leader>dO", function()
			dap.step_out()
		end, opts)

		-- Keymap to terminate debugging
		vim.keymap.set("n", "<leader>dq", function()
			require("dap").terminate()
		end, opts)

		-- Toggle DAP UI
		vim.keymap.set("n", "<leader>du", function()
			ui.toggle()
		end, opts)
	end,
}
