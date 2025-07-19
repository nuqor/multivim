{
  description = "Multivim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      plugins = with pkgs.vimPlugins; [
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
      runtimeDeps = with pkgs; [
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
      multivimPlugin = pkgs.vimUtils.buildVimPlugin {
        name = "multivim";
        src = ./multivim;
      };
      # extraPython3Packages = python-packages: with python-packages; [ ipython ];
    in
    {

      packages.${system}.default =
        (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
          plugins = [ multivimPlugin ] ++ plugins;
          luaRcContent = builtins.readFile ./init.lua;
          wrapperArgs = "--set MPL_BACKENDS_PATH ${./multivim/python/mpl_backends}";
          # withPython3 = true;
          # inherit extraPython3Packages;
        }).overrideAttrs
          (
            finalAttrs: previousAttrs: {
              runtimeDeps = previousAttrs.runtimeDeps ++ runtimeDeps;
            }
          );

    };

}
