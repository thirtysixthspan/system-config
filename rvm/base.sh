source "$HOME/.rvm/scripts/rvm"
rvm install ruby-2.3
rvm install ruby-2.4
rvm --default use ruby-2.3
gem install bundler rake rspec rails --no-rdoc --no-ri
