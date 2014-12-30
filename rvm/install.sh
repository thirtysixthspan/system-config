#!/bin/sh
#
# Install RVM

if test ! $(which rvm)
then
  echo "Installing rvm"
  \curl -sSL https://get.rvm.io | bash
fi

exit 0
