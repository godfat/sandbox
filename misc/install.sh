# ENV
GEM=~/.gem/ruby/2.3.0
OMNIBUS=/opt/gitlab/embedded

# Extra gems
$OMNIBUS/bin/gem install rib bond readline_buffer --user --no-ri --no-rdoc

# Run the console
sudo $OMNIBUS/bin/chpst -e /opt/gitlab/etc/gitlab-rails/env -U `whoami` env PATH=$GEM/bin:$OMNIBUS/bin:$PATH GEM_PATH=$GEM:$OMNIBUS/lib/ruby/gems EXECJS_RUNTIME=Disabled $OMNIBUS/bin/ruby -S $GEM/bin/rib all -rrib/extra/autoindent -rrib/extra/paging -p $OMNIBUS/service/gitlab-rails auto production
