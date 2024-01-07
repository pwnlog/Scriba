#!/usr/bin/bash

echo "[+] Installing dependencies"
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git
echo "[+] Installing Pyenv"
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> ~/.zshrc
echo "[+] Installing Python 2.7.18"
$HOME/.pyenv/bin/pyenv install 2.7.18
echo "[+] Installing Python 3.11"
$HOME/.pyenv/bin/pyenv install 3.11
echo "[+] Pyenv Versions"
$HOME/.pyenv/bin/pyenv versions