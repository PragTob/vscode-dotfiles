#!/bin/sh
# Dotfiles installer, run unattended by VS Code Dev Containers on container create.
#
# The host's `dotfiles.installCommand` setting must be empty, or a bare path relative to this
# repo's root - `install.sh`, never `~/dotfiles/install.sh` and never `bash install.sh`. The
# devcontainers CLI cd's into the checkout and runs the setting as `"./${installCommand}"`,
# with the `./` glued on and the whole thing double-quoted, so anything else becomes a
# nonsense filename that dies with 127 where you cannot see it. Empty is safest: install.sh
# is the first name the CLI auto-detects.
#
# "Where you cannot see it" is the other half. Nothing this script prints reaches the
# container - VS Code keeps it in the host's "Dev Containers" output panel - so everything is
# traced to install.log next to this file. No log at all means this never ran. Keep the log:
# three debugging rounds went into a script that was innocent, for want of that one fact.
set -eu

dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"
log="$dotfiles_dir/install.log"
exec >"$log" 2>&1
trap 'echo "install.sh: exit status $?"' EXIT
set -x

# Keyed on .git rather than the directory: an interrupted create leaves a directory with no
# checkout in it, and a plain -d guard would call that done forever, manual re-runs included.
clone() {
  [ -d "$2/.git" ] || git clone --quiet --depth=1 "$1" "$2"
}

# A plain clone is all of oh-my-zsh's official installer that matters here: the .zshrc it
# would generate is the one we symlink below instead, and it skips chsh when unattended anyway
# (the devcontainer already gives this user /bin/zsh).
zsh_dir="$HOME/.oh-my-zsh"
clone https://github.com/ohmyzsh/ohmyzsh "$zsh_dir"
clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_dir/custom/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_dir/custom/plugins/zsh-syntax-highlighting"

ln -sfn "$dotfiles_dir/.zshrc" "$HOME/.zshrc"
