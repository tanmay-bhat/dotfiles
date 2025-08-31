# Set the path to the Oh My Zsh installation directory
export ZSH="$HOME/.oh-my-zsh"

# Set the theme for the Zsh prompt
ZSH_THEME="robbyrussell"

# Configure automatic updates for Oh My Zsh
zstyle ':omz:update' mode auto

# Enable plugins for additional functionality
plugins=(git colored-man-pages colorize kube-ps1 kubectl)

# Source the main Oh My Zsh script
source $ZSH/oh-my-zsh.sh

# Enable syntax highlighting and autosuggestions
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Disable the end-of-line % character in the prompt
export PROMPT_EOL_MARK=''

# Skip global compinit to improve shell startup time
export skip_global_compinit=1

# Set the timestamp format for history entries
HIST_STAMPS="mm/dd/yyyy"

# Remove duplicate entries from the history
setopt HIST_IGNORE_ALL_DUPS

# Define an alias to fetch the public IP address
alias public_ip='curl wgetip.com'

# Configure kube-ps1 prompt settings
KUBE_PS1_SYMBOL_ENABLE=true
KUBE_PS1_NS_ENABLE=true

# Configure AWS and Kubernetes prompt settings
PS1='$(aws_ps1)$(kube_ps1)'$PS1

# Define aliases for kubectx and kubens
alias ctx='kubectx'
alias ns='kubens'

# Enable kubectl autocompletion if kubectl is installed
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Automatically switch AWS profile and region
asp prod-observer && asr us-west-2
