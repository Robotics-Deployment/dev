ARG PACKAGE
FROM ${PACKAGE}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  gnupg \
  sudo \
  wget \
  ca-certificates \
  tar \
  build-essential \
  git \
  xclip \
  xsel \
  cmake \
  unzip \
  openssh-client \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" >> /etc/apt/sources.list

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  llvm-17 \
  lldb-17 \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  cd /usr/bin && \
  for tool in llvm-*17; do \
  new_name=$(echo "$tool" | sed 's/-17$//'); \
  ln -s "$tool" "$new_name"; \
  done && \
  for tool in lldb-*17; do \
  new_name=$(echo "$tool" | sed 's/-17$//'); \
  ln -s "$tool" "$new_name"; \
  done

RUN useradd -m dev

RUN echo 'dev:dev' | chpasswd

RUN echo 'dev ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/dev

USER dev
WORKDIR /home/dev

RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz && \
  tar -xzf nvim-linux64.tar.gz && \
  sudo chmod +x nvim-linux64/bin/nvim && \
  sudo mv nvim-linux64 /opt/nvim && \
  rm nvim-linux64.tar.gz

RUN wget https://nodejs.org/dist/v20.11.0/node-v20.11.0-linux-x64.tar.xz && \
  tar -xJf node-v20.11.0-linux-x64.tar.xz && \
  sudo chmod +x node-v20.11.0-linux-x64/bin/node && \
  sudo mv node-v20.11.0-linux-x64 /opt/node && \
  rm node-v20.11.0-linux-x64.tar.xz

RUN wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Linux_x86_64.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && \
  sudo chmod +x lazygit && \
  sudo mv lazygit /usr/local/bin/ && \
  rm -rf lazygit.tar.gz

RUN mkdir -p lua-language-server && \
  wget -O lua-language-server.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/3.7.4/lua-language-server-3.7.4-linux-x64.tar.gz" && \
  tar xf lua-language-server.tar.gz -C lua-language-server && \
  sudo chmod +x lua-language-server/bin/lua-language-server && \
  sudo mv lua-language-server /opt/lua && \
  rm -rf lua-language-server.tar.gz

RUN wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 && \
  sudo mv hadolint-Linux-x86_64 /usr/local/bin/hadolint && \
  sudo chmod +x /usr/local/bin/hadolint

RUN wget https://github.com/artempyanykh/marksman/releases/download/2023-12-09/marksman-linux-x64 && \
  sudo mv marksman-linux-x64 /usr/local/bin/marksman && \
  sudo chmod +x /usr/local/bin/marksman

ENV PATH=/opt/nvim/bin:$PATH
ENV PATH=/opt/node/bin:$PATH
ENV PATH=/opt/lua/bin:$PATH

RUN npm install -g \
  vscode-json-languageserver \
  yaml-language-server \
  dockerfile-language-server-nodejs \
  svelte-language-server \
  typescript-language-server \
  eslint \
  prettier \
  playwright \
  vitest \
  @tailwindcss/language-server
