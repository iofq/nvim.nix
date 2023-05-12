FROM nixos/nix

COPY . .

RUN nix bundle --bundler github:ralismark/nix-appimage .

ENTRYPOINT [ "nvim-x86_64.AppImage" ]
