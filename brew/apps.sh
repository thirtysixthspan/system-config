apps=(
  google-chrome
  firefox
  vagrant
  iterm2
  sequel-pro
  ffmpegx
  nmap
  transmission
  keepassx
  omnigraffle
  sublime-text3
  virtualbox
  skype
  karabiner
)
brew tap caskroom/versions
brew cask install --appdir="/Applications" ${apps[@]}
