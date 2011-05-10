
require.paths.unshift "/usr/local/lib/node_modules/express/lib"

express = require 'express'

app = express.createServer()

app.get('*', (req, res) ->
  res.send("Hello, World!\n"))

app.listen(8080)
