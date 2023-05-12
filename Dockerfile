FROM nixos/nix

ADD .

RUN nix bundle --bundler github:ralismark/nix-appimage .

ENTRYPOINT [ "nvim-x86_64.AppImage" ]
