apps=(
  google-chrome
  firefox
  vagrant
  iterm2
  sequel-pro
  ffmpegx
  transmission
  macpass
  sublime-text
  virtualbox
  skype
  karabiner
  valentina-studio
  bettertouchtool
  caffeine
  paw
  screenhero
  shiftit
  robomongo
  jq
)
brew tap caskroom/versions
brew cask install --appdir="/Applications" ${apps[@]}
