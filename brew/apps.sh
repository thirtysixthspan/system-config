apps=(
  google-chrome
  firefox
  vagrant
  iterm2
  sequel-pro
  ffmpegx
  transmission
  keepassx
  sublime-text
  virtualbox
  skype
  karabiner
  valentina-studio
  bettertouchtool
  caffeine
  paw
  screenhero
)
brew tap caskroom/versions
brew cask install --appdir="/Applications" ${apps[@]}
