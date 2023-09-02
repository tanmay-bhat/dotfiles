
# function to print current AWS profile
function agp() {
  echo $AWS_PROFILE
}

# function to print current AWS region
function agr() {
  echo $AWS_REGION
}

# function to list all the profiles in ~/.aws/config
function aws_profiles() {
  aws --no-cli-pager configure list-profiles 2> /dev/null && return
  if [ -f $HOME/.aws/config ]; then
    grep -Eo '\[.*\]' $HOME/.aws/config | grep -v sso-session | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
  else
    echo "$HOME/.aws/config not found"
  fi
}

# function to set AWS profile, sso login and clear the profile
function asp() {
  if [[ "$1" == "login" ]]; then
    aws sso login
    return
  fi

  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE
    echo "Zero argument provided, AWS profile cleared."
    return
  fi

  local -a available_profiles
  available_profiles=($(aws_profiles))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "Profile '$1' not found in '$HOME/.aws/config'" >&2
    echo "Available profiles: ${available_profiles[*]}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  export AWS_PROFILE_REGION=$(aws configure get region)
}

# function to set AWS region and clear the region
function asr() {
  if [[ -z "$1" ]]; then
    echo "No argument provided, Updating AWS region to 'us-west-2'."
    export AWS_REGION='us-west-2'
    export AWS_DEFAULT_REGION='us-west-2'
    return
  else
    export AWS_DEFAULT_REGION=$1
    export AWS_REGION=$1
  fi
}

# Set ReadOnly profile as default profile
asp prod-observer
asr us-west-2

#function to update the PS1 prompt with current AWS profile and region
# function aws_ps1() {
#   echo "[$AWS_PROFILE:$AWS_REGION]"
# }

function aws_ps1() {
  local profile_color="\e[36m"  # Cyan color
  local region_color="\e[32m"   # Green color
  local reset_color="\e[0m"     # Reset color

  echo -e "($profile_color$AWS_PROFILE$reset_color:$region_color$AWS_REGION$reset_color)"
}