# Ubuntu packages
sudo apt install -y build-essential cmake libicu-dev pkg-config libpq-dev ruby-dev libreadline-dev nodejs libkrb5-dev

# ENV
export PATH=~/.gem/ruby/2.3.0/bin:$PATH
export BUNDLE_APP_CONFIG=~/.bundle
root=/opt/gitlab/embedded/service/gitlab-rails

# bundler and other gems
gem install bundler rib bond readline_buffer --user --no-ri --no-rdoc

# bundle install
bundle install --gemfile $root/Gemfile --path ~/.gem --without mysql

# Run the console
sudo -E rib all -rrib/extra/autoindent -rrib/extra/paging -p $root auto production
