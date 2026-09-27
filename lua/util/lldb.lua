-- Locate the lldb-dap debug adapter on Linux (apt) and macOS (Xcode/MacPorts).
local M = {}

local cached

local function find()
	if vim.fn.executable("lldb-dap") == 1 then
		return vim.fn.exepath("lldb-dap")
	end

	-- macOS: Xcode's toolchain isn't on PATH
	if vim.fn.executable("xcrun") == 1 then
		local res = vim.system({ "xcrun", "-f", "lldb-dap" }, { text = true }):wait()
		if res.code == 0 then
			return vim.trim(res.stdout)
		end
	end

	-- Versioned binaries, e.g. /usr/bin/lldb-dap-19 (apt), /opt/local/bin/lldb-dap-mp-19 (MacPorts)
	local candidates = {}
	for _, dir in ipairs({ "/usr/bin", "/opt/local/bin" }) do
		vim.list_extend(candidates, vim.fn.glob(dir .. "/lldb-dap-*", false, true))
	end
	if #candidates > 0 then
		table.sort(candidates, function(a, b)
			return (tonumber(a:match("(%d+)$")) or 0) < (tonumber(b:match("(%d+)$")) or 0)
		end)
		return candidates[#candidates]
	end
end

-- Path to lldb-dap, or nil if it isn't installed. The lookup runs once.
function M.path()
	if cached == nil then
		cached = find() or false
	end
	return cached or nil
end

return M
