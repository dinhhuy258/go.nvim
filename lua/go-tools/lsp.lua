local M = {}

function M.setup(common_on_attach, common_capabilities, common_on_init)
  local status, lsp_installer = pcall(require, "nvim-lsp-installer")
  if not status then
    return
  end

  local ok, server = lsp_installer.get_server "gopls"
  if not ok then
    return
  end

  if server:is_installed() then
    server:setup {
      on_attach = common_on_attach,
      on_init = common_on_init,
      capabilities = common_capabilities,
    }
    vim.cmd [[ do User LspAttachBuffers ]]
  end
end

return M
