local M = {}

function M.setup(common_on_attach, common_capabilities, common_on_init)
  local status, lspconfig = pcall(require, "lspconfig")

  if not status then
    return
  end

  lspconfig.gopls.setup {
    cmd = {
      vim.fn.stdpath "data" .. "/lsp_servers/go/gopls",
    },
    on_attach = common_on_attach,
    on_init = common_on_init,
    capabilities = common_capabilities,
  }
end

return M
