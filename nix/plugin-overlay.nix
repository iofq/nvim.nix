{ inputs, ... }:
final: prev:
let
  mkNvimPlugin =
    src: pname:
    prev.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
in
{
  vimPlugins = prev.vimPlugins.extend (
    final': prev': {
      dart-nvim = mkNvimPlugin inputs.dart "dart.nvim";
      nvim-treesitter-textobjects = mkNvimPlugin inputs.nvim-treesitter-textobjects "nvim-treesitter-textobjects";
      nvim-treesitter = prev'.nvim-treesitter.overrideAttrs (old: rec {
        src = inputs.nvim-treesitter;
        name = "${old.pname}-${src.rev}";
        postPatch = "";
        # ensure runtime queries get linked to RTP (:TSInstall does this too)
        buildPhase = "
          mkdir -p $out/queries
          cp -a $src/runtime/queries/* $out/queries
        ";
        nvimSkipModules = [ "nvim-treesitter._meta.parsers" ];
      });
    }
  );
}
