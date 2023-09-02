##############################################################################
# Zsh settings
##############################################################################
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Update automatically without asking
zstyle ':omz:update' mode auto

plugins=(aws git colored-man-pages colorize kube-ps1 kubectl)

source $ZSH/oh-my-zsh.sh
#PROMPT=$PROMPT'$(aws_ps1) '

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Disable the EOL % character.
export PROMPT_EOL_MARK=''

##############################################################################
# History settings
##############################################################################
HIST_STAMPS="mm/dd/yyyy"

#remove duplicates from history
setopt HIST_IGNORE_ALL_DUPS

##############################################################################
# User configuration
##############################################################################
#GCP alias
alias gs='gcloud compute ssh'
alias gsp='gcloud config set project'


# Networking alias
public_ip='curl wgetip.com'
private_ip='hostname -i'

#kube ps1 settings
source /usr/local/opt/kube-ps1/share/kube-ps1.sh
PS1='$(kube_ps1)'$PS1

#aws ps1 settings
#source /usr/local/share/aws-ps1/aws-ps1.plugin.zsh
#PROMPT=$PROMPT'$(aws_ps1) '

#AWS alias functions.

#function to list all the secrets in a region
function aws_secrets_list() {

    #define help
    if [[ $1 == "-h" || $1 == "--help" ]]; then
        echo "Usage: aws_secrets_list <profile> <region> <filter string>"
        return 0
    fi
    #default region is us-west-2 if not specified
    region=${2-'us-west-2'}
    aws secretsmanager list-secrets --profile $1 --region $region | jq -r ".SecretList[].Name" | grep -i $3
}

#function to get the value of a specified secret
function aws_secrets_retrive() {

    #define help
    if [[ $1 == "-h" || $1 == "--help" ]]; then
        echo "Usage: aws_secrets_retrive <profile> <secret_name> <region>"
        return 0
    fi

    #default region is us-west-2 if not specified
    region=${3-'us-west-2'}

    aws secretsmanager --profile $1 get-secret-value --secret-id $2 --region $region | jq -r '.SecretString'
}

#function to decrypt base64 encoded kubernetes secret.
function k8s_decrypt() {
    #define help
    if [[ $1 == "-h" || $1 == "--help" ]]; then
        echo "Usage: k8s_decrypt <secret name> <namespace>"
        return 0
    fi

    #default namespace is default if not specified
    namespace=${2-'default'}

    kubectl get secret $1 -n $namespace -o json | jq -r '.data | map_values(@base64d)'
}

# Postgres client path
#export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
