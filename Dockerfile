FROM nixos/nix

WORKDIR /app
COPY . .

RUN nix bundle \
    --bundler github:ralismark/nix-appimage \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    .

ENTRYPOINT [ "nvim-x86_64.AppImage" ]
