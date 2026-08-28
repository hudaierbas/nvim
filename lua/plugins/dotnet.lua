-- C# / Unity desteği
--
-- NOT: csharpier'in çalışması için `aspnet-runtime-10.0` paketi gerekiyor
-- (ASP.NET Core shared framework). Kurulu değilse formatlama sessizce başarısız
-- olur; LSP tarafı bundan etkilenmez.

return {
  -- OmniSharp'ın yerini alan resmî Roslyn sunucusu (vscode C# eklentisiyle aynı).
  -- Unity 6.5'in ürettiği .slnx çözüm dosyasını tanıyor.
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- Unity'nin Library/ klasörü devasa (3+ GB). Dosya izlemeyi neovim yerine
      -- sunucuya bırakmak, sunucu yalnızca projeye dahil dosyaları izlediği için
      -- inotify yükünü ortadan kaldırıyor.
      filewatching = "roslyn",
    },
    init = function()
      vim.lsp.config("roslyn", {
        settings = {
          -- Proje küçük; tüm çözümü analiz etmek açık olmayan dosyalardaki
          -- derleme hatalarını da gösteriyor. Büyük projede "openFiles" yap.
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          -- UnityEngine.dll gibi kaynağı olmayan derlemelerde `gd` ile
          -- decompile edilmiş koda atlamayı sağlar
          ["navigation"] = {
            dotnet_navigate_to_decompiled_sources = true,
          },
        },
      })
    end,
  },

  -- mason-lspconfig, roslyn-language-server paketini görünce lspconfig'in
  -- `roslyn_ls` sunucusunu da otomatik açmak ister. roslyn.nvim kendi `roslyn`
  -- istemcisini yönettiği için çift bağlanmayı önlemek üzere kapatıyoruz.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        roslyn_ls = { enabled = false },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "roslyn-language-server", "csharpier" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
    },
  },
}
