#!/usr/bin/env bash

# Install tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

brew install git hub rcm

brew install coreutils
brew install moreutils
brew install findutils

brew install tmux reattach-to-user-namespace

brew install grep ack pv tree htop wget
brew install gnu-sed --with-default-names

brew install nvm

brew install unzip
brew install imagemagick
brew install nmap
brew install autojump
brew install jq

brew cleanup
