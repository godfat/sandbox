sudo apt install -y build-essential cmake libicu-dev pkg-config libpq-dev ruby-dev libreadline-dev nodejs

export PATH=~/.gem/ruby/2.3.0/bin:$PATH
export BUNDLE_APP_CONFIG=~/.bundle
rails_root=/opt/gitlab/embedded/service/gitlab-rails

gem install bundler rib bond readline_buffer --user --no-ri --no-rdoc

env BUNDLE_GEMFILE=$rails_root/Gemfile bundle install --path ~/.gem --without mysql:kerberos

rib all -p $rails_root auto
