# Ubuntu packages
sudo apt install -y build-essential cmake libicu-dev pkg-config libpq-dev ruby-dev libreadline-dev nodejs libkrb5-dev

# ENV
GEM=~/.gem/ruby/2.3.0
OMNIBUS=/opt/gitlab/embedded
ROOT=$OMNIBUS/service/gitlab-rails

# Extra gems
$OMNIBUS/bin/gem install rib bond --user --no-ri --no-rdoc

# Run the console
sudo $OMNIBUS/bin/chpst -e /opt/gitlab/etc/gitlab-rails/env -U `whoami` env PATH=$GEM/bin:$OMNIBUS/bin:$PATH GEM_PATH=$GEM:$OMNIBUS/lib/ruby/gems rib all -rrib/extra/paging -p $ROOT auto production
