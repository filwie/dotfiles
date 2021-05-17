FROM archlinux:base-devel

# --- Install tools ---
RUN pacman --quiet -Sy --noconfirm \
        git fish neovim tmux \
        openssh ansible python \
        kubectl

# --- Configure User ---
ARG USER_NAME=filwie
ARG USER_HOME="/${USER_NAME}"
RUN useradd -m -G wheel -d "$USER_HOME" -s /usr/bin/fish filwie

RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $USER_NAME

ENV XDG_DATA_HOME="${USER_HOME}/.local/share"
ENV XDG_CONFIG_HOME="${USER_HOME}/.config"

COPY --chown="$USER_NAME:$USER_NAME" ./home/.config "$XDG_CONFIG_HOME"

# --- Install Plugins ---
ARG TPM_DIR="${XDG_DATA_HOME}/tmux/plugins/tpm"
ARG PLUG_PATH="${XDG_DATA_HOME}/nvim/site/autoload/plug.vim"

RUN git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" > /dev/null \
    && curl -fLo  --create-dirs "$PLUG_PATH" > /dev/null \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && nvim --headless +PlugInstall +qall > /dev/null

WORKDIR "$USER_HOME"
CMD ["/usr/bin/fish", "--login"]
