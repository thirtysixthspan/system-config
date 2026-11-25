#!/bin/sh
#
# Install Homebrew

if test ! $(which brew)
then
  echo "Installing Homebrew, but see https://gist.github.com/ijagjeet/72b6c0c3174af38500cd4baf28c2c02c"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

exit 0
