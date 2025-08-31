# function to list all the profiles in ~/.aws/config
function aws_profiles() {
  profiles=$(aws --no-cli-pager configure list-profiles 2> /dev/null)
  if [[ -z "$profiles" ]]; then
    echo "No AWS profiles found in '$HOME/.aws/config, check if ~/.aws/config exists and properly configured.'"
    return 1
  else
    echo $profiles
  fi
}

# function to set AWS profile, sso login and clear the profile
function asp() {
  available_profiles=$(aws_profiles)
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE
    echo "Zero argument provided, AWS profile cleared."
    return
  fi
  
  echo "$available_profiles" | grep -qw "$1"
  if [[ $? -ne 0 ]]; then
    echo "Profile '$1' not configured in '$HOME/.aws/config'.\n"
    echo "Available profiles: \n$available_profiles\n"
    return 1
  else
    export AWS_DEFAULT_PROFILE="$1" AWS_PROFILE="$1"
  fi
}

# function to set AWS region and clear the region
function asr() {
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_REGION AWS_REGION
    echo "No argument provided, cleared AWS region."
    return
  else
    export AWS_DEFAULT_REGION=$1 AWS_REGION=$1
  fi
}

# function to list all the profiles
function alp() {
  aws_profiles
}

# function to update the PS1 prompt with current AWS profile and region
function aws_ps1() {
  local profile_color="%{$(tput setaf 6)%}"  # Cyan color
  local region_color="%{$(tput setaf 2)%}"   # Green color
  local reset_color="%{$(tput sgr0)%}"      # Reset color
  echo -en "($profile_color$AWS_PROFILE$reset_color:$region_color$AWS_REGION$reset_color)"
}
