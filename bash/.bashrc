#
# ~/.bashrc
#

export ANDROID_HOME=$HOME/Android/Sdk
export PATH="$HOME/.npm-global/bin:$PATH:$ANDROID_HOME/platform-tools"
# Sửa lỗi trắng màn hình Java trên Arch Linux (Hyprland/Wayland)
export _JAVA_AWT_WM_NONREPARENTING=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export NO_AT_BRIDGE=1
export _JAVA_OPTIONS='-Dsun.java2d.opengl=false -Dsun.java2d.xrender=false'
export WB_FORCE_SYSTEM_COLORS=1
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#c4c4c4,bg:#121212,hl:#8d60db --color=fg+:#dbdbdb,bg+:#262626,hl+:#cba8ff --color=info:#79c2c9,prompt:#00ffe1,pointer:#af5fff --color=marker:#6da9d1,spinner:#af5fff,header:#87afaf'
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '

alias ollama-on='sudo systemctl start ollama.service'
alias ollama-off='sudo systemctl stop ollama.service'
alias db='cd ~/schema && nvim -c "DBUIToggle"'

eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"

# Bash history
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups

# Kiểm tra nếu KHÔNG phải là terminal trong Neovim thì mới chạy fastfetch
if [ -z "$NVIM" ] && [ -z "$VIMRUNTIME" ]; then
  fastfetch
fi
