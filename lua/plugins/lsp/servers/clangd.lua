local util = require 'lspconfig.util'
print("config loaded")
-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  if clangd_client then
    clangd_client.request('textDocument/switchSourceHeader', params, function(err, result)
      if err then
        error(tostring(err))
      end
      if not result then
        print 'Corresponding file cannot be determined'
        return
      end
      vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
    end, bufnr)
  else
    print 'method textDocument/switchSourceHeader is not supported by any servers active on the current buffer'
  end
end


local function symbol_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = util.get_active_client_by_name(bufnr, 'clangd')
  if not clangd_client or not clangd_client.supports_method 'textDocument/symbolInfo' then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local params = vim.lsp.util.make_position_params()
  clangd_client.request('textDocument/symbolInfo', params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is not reason to parse it
      return
    end
    local container = string.format('container: %s', res[1].containerName) ---@type string
    local name = string.format('name: %s', res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      border = require('lspconfig.ui.windows').default_options.border or 'single',
      title = 'Symbol Info',
    })
  end, bufnr)
end


local root_files = {
  '.clangd',
  '.clang-tidy',
  '.clang-format',
  'compile_commands.json',
  'compile_flags.txt',
  'configure.ac', -- AutoTools
}



local default_capabilities = {
  textDocument = {
    completion = {
      editsNearCursor = true,
    },
  },
  offsetEncoding = { 'utf-8', 'utf-16' },
}


return {
  cmd = {
    "/usr/bin/clangd",
    "-j=48",
		"--enable-config",
    "--background-index",
	  "--pch-storage=memory",
			-- -- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
			-- "--query-driver=" .. get_binary_path_list({ "clang++", "clang", "/usr/bin/gcc", "/usr/bin/g++" }),
		"--clang-tidy",
		"--all-scopes-completion",
		"--completion-style=detailed",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
		"--limit-references=3000",
		"--limit-results=350",
    "-Iinclude",
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  root_dir = function(fname)
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
  single_file_support = true,
  capabilities = default_capabilities,
  diagnostics = {
    IgnoreHeader = { ".*cuda\\.h" },
  },
  commands = {
    ClangdSwitchSourceHeader = {
      function()
        switch_source_header(0)
      end,
      description = 'Switch between source/header',
    },
    ClangdShowSymbolInfo = {
      function()
        symbol_info()
      end,
      description = 'Show symbol info',
    },
  },
  docs = {
    -- ...
  },
}
