#!/bin/sh
#
# Install kiex - Elixir Version Manager

if test ! $(which kiex)
then
  echo "Installing kiex"
  \curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
fi

exit 0
