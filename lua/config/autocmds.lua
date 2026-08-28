-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function set_transparent_bg()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "SignColumnNC",
    "EndOfBuffer",
    "MsgArea",
    "FloatBorder",
    "WinSeparator",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_transparent_bg,
})

set_transparent_bg()

-- Unity projesinde acilan nvim, Unity'nin dosya acma isteklerini karsilayabilsin
-- diye sabit bir sokette dinlemeye baslar (bkz. ~/.local/bin/unity-nvim).
-- Soketi baska bir nvim tutuyorsa sessizce vazgecer.
-- NOT: bu dosya VeryLazy'de yuklendigi icin VimEnter autocmd'i ise yaramaz,
-- kod dogrudan calistiriliyor.
local function start_unity_server()
  -- Unity projesi mi? ProjectSettings/ProjectVersion.txt'yi yukari dogru ara
  local in_unity_project = false
  for dir in vim.fs.parents(vim.fn.getcwd() .. "/.") do
    if vim.uv.fs_stat(dir .. "/ProjectSettings/ProjectVersion.txt") then
      in_unity_project = true
      break
    end
  end
  if not in_unity_project then
    return
  end

  local sock = vim.fs.joinpath(vim.env.XDG_RUNTIME_DIR or "/tmp", "nvim-unity.sock")
  if vim.uv.fs_stat(sock) then
    -- Baglanabiliyorsak baska bir nvim dinliyordur; baglanamiyorsak artik sokettir
    local ok, chan = pcall(vim.fn.sockconnect, "pipe", sock, { rpc = true })
    if ok and chan ~= 0 then
      pcall(vim.fn.chanclose, chan)
      return
    end
    vim.uv.fs_unlink(sock)
  end
  pcall(vim.fn.serverstart, sock)
end

start_unity_server()
