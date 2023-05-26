FROM nixos/nix

WORKDIR /app
COPY . .

RUN nix bundle \
    --bundler github:ralismark/nix-appimage \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes .#full && \
    mv $(realpath nvim-x86_64.AppImage) neovim-x86_64-linux.AppImage && \
    nix-collect-garbage

RUN nix bundle \
    --bundler github:ralismark/nix-appimage \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes .#minimal && \
    mv $(realpath nvim-x86_64.AppImage) neovim-x86_64-linux-minimal.AppImage && \
    nix-collect-garbage
