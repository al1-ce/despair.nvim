# despair.nvim

A soft fork of my monolith.nvim with removal of 90% of everything that's not completely necessary or that's related or is a plugin.

Also it is a test to how much of plugins I really need and how much of them I can replace with native vim/neovim functionality and a way to learn actual inner workings and proper mappings.

*After some time I can say that it all can be fairly simply replicated without anything remotely remote (pun intended), but I'd still occasionally would use Monolith distro just because it's convenient and sometimes convenient is exactly what I need (and lsp).*

## Dependencies

Dependency list is incredibly small (especially in comparison to Monolith).

```
- neovim  (required, obviously)
- ripgrep (optional, if you want to use `<leader>f*` bindings)
- just    (optional, if you want to use `<leader>b*` bindings)
```

Both non-nvim deps are optional and I'm happy with how it came out. For `just` you can use `:make` instead and for `ripgrep` you can use `:find` and `:grep`. Pretty darn good job I'd say.

If `ripgrep` (`rg` binary) is not present or `vim.g.use_search_find` option set then `<leader>f*` bindings will use `find` and `grep`.

If `just` is not present or `vim.g.use_build_make` option set then `<leader>b*` bindings will use make.

To be honest gotta use them, with `:silent lgrep! "what" | lopen` and `:make! | copen`. Would be nice to have `:find` (there's `:sfind` which can be of use) be able to output to loclist though.

Gotta learn make... I guess..?

## Structure

```
.
├── after
│   ├── ftdetect       - most of filetype detect, other's are in sil-filetypes
│   ├── ftplugin       - filetype plugins, mostle commentstrings
│   ├── indent         - indent files
│   └── syntax         - syntax files
│       └── zdoomlumps - gzdoom lumps (see plugin/sil/sil-filetypes.lua)
├── colors             - colorscheme
├── docs               - this readme, license, etc
├── lua
│   ├── lib            - common functions, aka utils
│   └── opt            - neovim options
└── plugin
    ├── des            - standalone "plugins" related to this distro
    └── sil            - standalone "plugins" related to both distros
```

Monolith distro shares almost same structure with exception of: `lua/aft`, `lua/plf`, `lua/plg`, `lspconf`, `snippets` and `plugin/des` => `plugin/mon` (with own distro related "plugins") which are all related to actual remote plugins managed by `lazy.nvim` config of which is located in `lua/plf/lzy.lua`.

Both distros share everything from Despair with exception of `plugin/des` which replaces Monolith's remote plugins.

## Notice

#### This distro is not supposed or intended to be perfect out of the box experience. It is preconfigured to be vanilla-like friendly experience, but for your personal needs changing configs will be required.
#### If this doesn't suit you then please look at [other NeoVim distributions](#other-neovim-distributions)

## Other NeoVim distributions
- [AstroNvim](https://github.com/AstroNvim/AstroNvim)
- [CosmicNvim](https://github.com/CosmicNvim/CosmicNvim)
- [LunarVim](https://github.com/LunarVim/LunarVim)
- [NvChad](https://github.com/NvChad/NvChad)
