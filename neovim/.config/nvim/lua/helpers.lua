local M = {}

-- Custom file picker that includes hidden and ignored files
function M.files_all()
	local show_with_icons = function(buf_id, items, query)
		return require('mini.pick').default_show(buf_id, items, query, { show_icons = true })
	end
	local postprocess = function(lines)
		return vim.tbl_map(function(l) return l:gsub('^%./', '') end, lines)
	end
	return require('mini.pick').builtin.cli(
		{ command = { 'rg', '--files', '--hidden', '--no-ignore' }, postprocess = postprocess },
		{ source = { show = show_with_icons } }
	)
end

-- Custom grep_live picker that includes hidden and ignored files
function M.grep_live_all()
	local show_with_icons = function(buf_id, items, query)
		return require('mini.pick').default_show(buf_id, items, query, { show_icons = true })
	end

	local process
	local cwd = vim.fn.getcwd()
	local set_items_opts = { do_match = false }
	local spawn_opts = { cwd = cwd }

	local match = function(_, _, query)
		pcall(vim.loop.process_kill, process)
		if #query == 0 then return require('mini.pick').set_picker_items({}, set_items_opts) end

		local pattern = table.concat(query)
		local command = {
			'rg', '--column', '--line-number', '--no-heading', '--color=never',
			'--hidden', '--no-ignore', '--', pattern
		}
		process = require('mini.pick').set_picker_items_from_cli(command, {
			set_items_opts = set_items_opts,
			spawn_opts = spawn_opts
		})
	end

	return require('mini.pick').start({
		source = {
			name = 'Grep live (rg)',
			items = {},
			match = match,
			show = show_with_icons,
			cwd = cwd
		}
	})
end

return M

