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
      # pluginConfig = pkgs: {
      #   package = pkgs.vimPlugins.catppuccin-nvim;
      #   runtimeDeps = [ ];
      #   dependencies = [ ];
      # };
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
        (pkgs.vimUtils.buildVimPlugin {
          name = "multivim";
          src = ./multivim;
        }).overrideAttrs
          { nvimSkipModules = [ "dependencies" ]; };
      # pluginsRepos =
      #   pkgs:
      #   pkgs.lib.pipe (plugins pkgs) [
      #     (map (plugin: plugin.src.url))
      #     (map (
      #       url:
      #       (builtins.concatStringsSep "/" (
      #         pkgs.lib.take 2 (builtins.match "https://github.com/(.*?)/(.*?)(\.git|/archive/.*)" url)
      #       ))
      #     ))
      #     (builtins.concatStringsSep "\n")
      #   ];
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
              wrapperArgs = "--set MPL_BACKENDS_PATH ${./multivim/python/mpl_backends} --set NVIM_NIX_NATIVE 1";
            }).overrideAttrs
              (
                finalAttrs: previousAttrs: {
                  runtimeDeps = previousAttrs.runtimeDeps ++ (runtimeDeps pkgs);
                }
              )
          );

          neovim-nix-native-dev = (
            (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
              plugins = (plugins pkgs);
              wrapperArgs = "--set MPL_BACKENDS_PATH ${./multivim/python/mpl_backends} --set NVIM_NIX_NATIVE 1";
            }).overrideAttrs
              (
                finalAttrs: previousAttrs: {
                  runtimeDeps = previousAttrs.runtimeDeps ++ (runtimeDeps pkgs);
                }
              )
          );

          # export =
          #   let
          #     packpathDirs = pkgs.neovimUtils.packDir self.packages.${system}.neovim.passthru.packpathDirs;
          #   in
          #   pkgs.writeShellApplication {
          #     name = "export-neovim-config";
          #     # text = "echo ${self.packages.${system}.neovim.passthru.packpathDirs}";
          #     text = "echo ${packpathDirs}";
          #   };
        }
      );

      devShells = eachSystem (
        system: pkgs: {

          nix-native = (
            pkgs.mkShell {
              buildInputs = [
                pkgs.git
                self.packages.${system}.neovim-nix-native-dev
              ];
              shellHook = ''
                export XDG_CONFIG_HOME=$(git rev-parse --show-toplevel)
                export NVIM_APPNAME=multivim
              '';
            }
          );

        }
      );

      # devShells = eachSystem (
      #   system: pkgs: {
      #     default =
      #       (pkgs.buildFHSEnv {
      #         name = "neovim-dev";
      #         targetPackages = [ self.packages.${system}.neovim ];
      #       }).env;
      #   }
      # );

    };

}
