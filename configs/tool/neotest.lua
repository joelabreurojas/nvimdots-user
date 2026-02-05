return function()
	require("neotest").setup({
		status = {
			enabled = true,
			signs = true,
			virtual_text = true,
		},
		output = {
			enabled = true,
			open_on_run = "short", -- Automatically open output during runtime
		},
		output_panel = {
			enabled = true,
			open = "botright split | resize 15",
		},
		quickfix = {
			enabled = false,
			open = false,
		},

		adapters = {
			require("neotest-golang")({ -- Specify configuration
				go_test_args = {
					"-v",
					"-race",
					"-count=1",
					"-failfast",
					"-gcflags=all=-N",
					"-gcflags=all=-l",
				},
			}),
			require("neotest-rust")({
				args = {
					"--success-output final",
					"--failure-output final",
				},
				dap_adapter = "codelldb",
			}),
			require("neotest-python")({
				runner = "pytest",
				python = ".venv/bin/python" or "python3",
				dap = { adapter = "python" },
			}),
		},
	})
end
