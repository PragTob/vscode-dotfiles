export ZSH="$HOME/.oh-my-zsh"

# VS Code's dotfiles step is unattended and, when it fails, invisible from in here. Installing
# on first use makes that one slow terminal rather than a bare shell and a debugging session.
if [[ ! -r "$ZSH/oh-my-zsh.sh" ]]; then
  echo "oh-my-zsh missing - running ~/dotfiles/install.sh ..."
  sh "$HOME/dotfiles/install.sh" || echo "failed, see ~/dotfiles/install.log"
fi

ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"
