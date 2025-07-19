{
  description = "Multivim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      eachSystem =
        f: (nixpkgs.lib.attrsets.genAttrs systems (system: f system nixpkgs.legacyPackages.${system}));
      plugins =
        pkgs: with pkgs.vimPlugins; [
          catppuccin-nvim
          conform-nvim
          fidget-nvim
          gitsigns-nvim
          lualine-nvim
          neo-tree-nvim
          noice-nvim
          nvim-lint
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          nvim-web-devicons
          render-markdown-nvim
          smart-splits-nvim
          snacks-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          tiny-inline-diagnostic-nvim
          vim-slime
        ];
      runtimeDeps =
        pkgs: with pkgs; [
          lemminx
          markdownlint-cli
          marksman
          mdformat
          nixd
          nixfmt-rfc-style
          pyright
          ripgrep
          ruff
          stylua
          tombi
          vscode-langservers-extracted
          yaml-language-server
        ];
      multivimPlugin =
        pkgs:
        pkgs.vimUtils.buildVimPlugin {
          name = "multivim";
          src = ./multivim;
        };
    in
    {

      packages = eachSystem (
        system: pkgs: {
          default = self.packages.${system}.neovim;
          neovim = (
            (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
              plugins = [
                (multivimPlugin pkgs)
              ] ++ (plugins pkgs);
              luaRcContent = builtins.readFile ./init.lua;
              wrapperArgs = "--set MPL_BACKENDS_PATH ${./multivim/python/mpl_backends}";
            }).overrideAttrs
              (
                finalAttrs: previousAttrs: {
                  runtimeDeps = previousAttrs.runtimeDeps ++ (runtimeDeps pkgs);
                }
              )
          );
        }
      );

    };

}
