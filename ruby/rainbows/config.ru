
require 'async-rack' # for eventmachine only

use Rack::ContentType
use Rack::ContentLength
use Rack::CommonLogger

ok = [200, {}, ["ok\n"]]

map '/cpu' do
  run lambda{ |env|
    sleep 2
    ok
  }
end

# use :FiberSpawn
map '/io-fiber' do
  run lambda{ |env|
    Rainbows.sleep 2
    ok
  }
end

# use :CoolioFiberSpawn
map '/io-coolio' do
  run lambda{ |env|
    Rainbows.sleep 2
    ok
  }
end

# use :EventMachine
map '/io-em' do
  require 'rack/fiber_pool'
  use Rack::FiberPool
  run lambda{ |env|
    f = Fiber.current
    EM::Timer.new(2){ f.resume }
    Fiber.yield
    ok
  }
end
