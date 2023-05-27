FROM nixos/nix

WORKDIR /app
COPY . .

RUN nix bundle \
        -o nvim.AppImage \
        --bundler github:ralismark/nix-appimage \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes .#full && \
        mv $(realpath nvim.AppImage) neovim-x86_64-linux.AppImage && \
    nix bundle \
        -o nvim-minimal.AppImage \
        --bundler github:ralismark/nix-appimage \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes .#minimal && \
        mv $(realpath nvim-minimal.AppImage) neovim-x86_64-linux-minimal.AppImage && \
        nix-collect-garbage
