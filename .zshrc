# PATH
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:${LD_LIBRARY_PATH}"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Powerlevel10k instant prompt — must stay near the top
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete tmux)

# Auto-start tmux on zsh launch
ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

# LS_COLORS
export LS_COLORS="di=1;38;2;232;228;221:ln=1;38;2;229;201;192:so=1;38;2;179;156;137:pi=1;38;2;179;156;137:ex=1;38;2;229;201;192:bd=1;38;2;199;190;177:cd=1;38;2;199;190;177:su=1;38;2;229;201;192:sg=1;38;2;229;201;192:tw=1;38;2;214;214;212:ow=1;38;2;214;214;212:*.tar=0;38;2;199;190;177:*.zip=0;38;2;199;190;177:*.gz=0;38;2;199;190;177:*.py=0;38;2;214;214;212:*.md=0;38;2;229;201;192:*.json=0;38;2;199;190;177"

# Completion colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"