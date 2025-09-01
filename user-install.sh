# ----------------------------
# Install NVM + latest Node.js
# ----------------------------
if [[ ! -d "$HOME/.nvm" ]]; then
    echo "Installing NVM."
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | bash
fi

source "$HOME/.nvm/nvm.sh"  # This loads nvm
source "$HOME/.nvm/bash_completion"  # This loads nvm bash_completion

if ! command -v node &> /dev/null; then
    echo "Installing Node.js with NVM."
    nvm install --lts
    nvm alias default "lts/*"
fi


# ----------------------------
# Install vim-plug plugins
# ----------------------------
vim -es +PlugInstall +qall

