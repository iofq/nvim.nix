FROM nixos/nix as build

WORKDIR /app
COPY . .

RUN mkdir -p /out && \
    nix bundle \
        -o nvim.AppImage \
        --bundler github:ralismark/nix-appimage \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes .#full && \
        mv $(realpath nvim.AppImage) /out/neovim-x86_64-linux.AppImage && \
    nix bundle \
        -o nvim-minimal.AppImage \
        --bundler github:ralismark/nix-appimage \
        --extra-experimental-features nix-command \
        --extra-experimental-features flakes .#minimal && \
        mv $(realpath nvim-minimal.AppImage) /out/neovim-x86_64-linux-minimal.AppImage

FROM scratch
WORKDIR /out
COPY --from=build /out /out
