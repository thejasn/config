FROM alpine:edge

RUN apk add git neovim ripgrep alpine-sdk bash curl cargo go --update
RUN LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
# RUN /root/.local/bin/lvim

# RUN PATH=$PATH:/root/.local/bin

RUN echo "alias lvim='/root/.local/bin/lvim'" >> ~/.bashrc

WORKDIR /root/.config/lvim

COPY ./config.lua ./config.lua
COPY ./lazy-lock.json ./lazy-lock.json

RUN mkdir -p lua/user/lsp/languages

COPY ./lua/user/lsp/languages/go.lua ./lua/user/lsp/languages/go.lua
COPY ./lua/user/lsp/init.lua ./lua/user/lsp/init.lua
COPY ./lua/user/dap.lua ./lua/user/dap.lua
COPY ./lua/user/options.lua ./lua/user/options.lua
COPY ./lua/user/plugins.lua ./lua/user/plugins.lua

CMD ["/bin/bash"]
