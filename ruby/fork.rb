
ENV["TERM"] = "screen"
fork do
  ENV["TERM"] = "ansi"
  fork do
    ENV["TERM"] = "xterm"
  end
  Process.wait
end
Process.wait
puts(ENV["TERM"])
