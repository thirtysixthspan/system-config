source "$HOME/.rvm/scripts/rvm"
rvm install ruby-1.9
rvm install ruby-2.0
rvm install ruby-2.1
rvm install ruby-2.2
rvm --default use ruby-2.2
gem install bundler rake rspec rails --no-rdoc --no-ri
