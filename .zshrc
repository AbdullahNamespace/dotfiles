# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '${ZDOTDIR:-$HOME}/.zshrc'
autoload -Uz compinit
compinit -d ~/.zcompdump
# End of lines added by compinstall

# ===== Basic Settings (الإعدادات الأساسية) =====
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ===== History Options (خيارات التاريخ) =====
setopt extended_history       
setopt hist_expire_dups_first 
setopt hist_ignore_dups       
setopt hist_ignore_space      
setopt inc_append_history     
setopt share_history          

# ===== Useful Options (خيارات مفيدة) =====
setopt autocd                 
setopt correct                
setopt interactivecomments 
setopt notify               

# ===== Enhanced Prompt (واجهة الأوامر المحسنة) =====
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git

prompt_short_dir() {
  echo "${PWD/#$HOME/~}" | sed "s|\([^/]\)[^/]*/|\1/|g"
}

setopt prompt_subst

PROMPT='%F{cyan}%n@%m%f %F{yellow}$(prompt_short_dir)%f%F{red}${vcs_info_msg_0_}%f %# '

# ===== Completion Improvements (تحسين الاكتمال التلقائي) =====
zstyle ':completion:*' menu select              
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-zA-Z}'

# ===== Syntax Highlighting (تلوين بناء الجملة) =====
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ===== Autosuggestions (الاقتراحات التلقائية) =====
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
elif [[ -f $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
fi

# ===== Docker Settings (إعدادات Docker) =====
export DOCKER_HOST=unix:///var/run/docker.sock

# ===== PATH Management (إدارة المسارات المحسنة) =====
typeset -U path  # ضمان عدم تكرار المسارات

# إضافة Flutter إذا كان موجوداً (ديناميكي وآمن)
if [ -d "$HOME/development/flutter/bin" ]; then
    path=("$HOME/development/flutter/bin" $path)
fi

# إضافة المسارات الأساسية
path=(
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.config/composer/vendor/bin"
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/sbin"
    "/usr/bin"
    "$path[@]"
)

# ===== NVM (Node Version Manager) =====
export NVM_DIR="$HOME/.nvm"

# Lazy load NVM (تحميل فقط عند الحاجة)
lazy_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# تحديد الأوامر التي ستقوم بتشغيل nvm
for cmd in node npm npx yarn; do
  eval "$cmd(){ unset -f $cmd; lazy_load_nvm; $cmd \$@ }"
done

if [ -d "$HOME/.yarn/bin" ]; then
    path=("$HOME/.yarn/bin" $path)
fi

# ===== Aliases (أسماء مستعارة) =====
alias python='python3'
alias ls='ls --color=auto'
alias ll='ls -lah'

# ===== Security & Misc =====
umask 022 # أذونات الملفات الافتراضية الآمنة

# Disable all beeps (تعطيل الأصوات المزعجة)
setopt no_beep
setopt no_list_beep
setopt no_hist_beep

# ===== Local Configuration (إعدادات محلية خاصة بك) =====
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi
