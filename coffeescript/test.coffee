
express = require 'express'

app = express.createServer()

app.get('*', (req, res) ->
  res.send("Hello, World!\n"))

app.listen(8080)
