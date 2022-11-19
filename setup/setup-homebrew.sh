#!/usr/bin/env bash

set -e

# Install latest homebrew.

if ! type brew > /dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#install packages from the exported Brewfile

echo "Installing packages fom Brewfile\n"

brew bundle install

echo "Finished installing packages.\n"