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

brew install git hub thoughtbot/formulae/rcm

brew install coreutils
brew install moreutils
brew install findutils

brew install bash
brew install bash-completion
brew install tmux reattach-to-user-namespace

brew install grep ack pv tree htop wget
brew install gnu-sed --with-default-names

brew install node

brew install mysql postgresql redis memcached sqlite

brew install --build-from-source mplayer

brew install apple-gcc42
brew install make
brew install unzip
brew install openssl

brew install imagemagick

brew install nmap

# Command line navigation tool
brew install autojump

# Command line JSON parsing tool
brew install jq

brew install nginx

# Remove outdated versions from the cellar.
brew cleanup
