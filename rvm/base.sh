source "$HOME/.rvm/scripts/rvm"
rvm install ruby-2
rvm install ruby-3
rvm --default use ruby-3
gem install bundler rake rspec rails --no-rdoc --no-ri
