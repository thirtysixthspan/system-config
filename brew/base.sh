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

brew install homebrew/dupes/grep ack pv tree htop wget
brew install gnu-sed --with-default-names

brew install node

brew install mysql postgresql redis memcached sqlite

brew install mplayer

brew install caskroom/cask/brew-cask

brew install homebrew/dupes/apple-gcc42
brew install homebrew/dupes/make
brew install homebrew/dupes/unzip
brew install openssl

brew install imagemagick

# Remove outdated versions from the cellar.
brew cleanup
