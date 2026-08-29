return {
  -- ONLY add your own LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        pyright = {},

        -- Aktif TS sunucusu vtsls (bkz. config/options.lua -- neden tsgo degil).
        -- Bu proje cok buyuk: ~4080 ts/tsx dosya, ~416k satir kaynak,
        -- node_modules'te ~30k .d.ts. tsserver'in projeyi yuklemesi ~70 sn
        -- suruyor; o sure boyunca completion donuyor ve hata gosterilmiyor.
        --
        -- DIKKAT: asagidaki ayarlar olculdu, yukleme suresini kayda deger
        -- sekilde DEGISTIRMEDI (70.2 sn -> 69.1 sn). Darbogaz oto-import
        -- indeksi degil, programin Node uzerinde kurulmasi. Ayarlar yine de
        -- dogru olan (bellek tavani, gereksiz ATA), o yuzden duruyorlar --
        -- ama hiz bekleme.
        vtsls = {
          settings = {
            typescript = {
              -- includePackageJsonAutoImports = "off" denendi ve KALDIRILDI:
              -- olcumde hiz kazanci vermedi (70.2 sn -> 69.1 sn, gurultu icinde),
              -- buna karsilik projede henuz hicbir yerde import edilmemis bir
              -- paketin oto-import onerisi olarak cikmasini engelliyor.
              -- vtsls'te kalmanin sebebi import ergonomisi oldugu icin
              -- varsayilan ("auto") dogru tercih.
              tsserver = {
                -- Olcumde tsserver 1.6 GB'a cikiyor, varsayilan sinir 3 GB.
                -- Sinira yaklasinca GC kirbaclamasi basliyor.
                maxTsServerMemory = 8192,
              },
              -- ATA ~/.cache/typescript'e @types/react@19 indirmisti; proje
              -- React 18 (@types/react 18.3.20). Tum @types zaten node_modules'te,
              -- ATA'nin yapacak isi yok.
              disableAutomaticTypeAcquisition = true,
            },
          },
        },
      },
    },
  },
}
