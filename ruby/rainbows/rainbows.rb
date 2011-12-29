
worker_processes 1

Rainbows! do
  # use                      :FiberSpawn
  use                      :CoolioFiberSpawn
  # use                      :EventMachine
  worker_connections        400

  keepalive_timeout         0
  client_max_body_size      5*1024*1024
  client_header_buffer_size 8*1024
end
