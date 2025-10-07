{ pkgs, lib }:
{
  plugins ? [ ],
  packages ? [ ],
}:
let
  finalPlugins = plugins ++ [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "iofq-nvim";
      src = lib.cleanSource ../nvim;
      version = "0.1";
      doCheck = false;
    })
  ];
  wrapperArgs = ''--prefix PATH : "${lib.makeBinPath packages}"'';
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
  inherit wrapperArgs;
  plugins = finalPlugins;
  withPython3 = false;
  withRuby = false;
  vimAlias = true;
}
