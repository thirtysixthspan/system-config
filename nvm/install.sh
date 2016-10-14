#!/bin/sh
#
# Install NVM

if test ! $(which nvm)
then
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
fi

exit 0
