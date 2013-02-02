app = require('express')()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

server.listen(80)

app.get('/', (req, res) ->
  res.sendfile(__dirname + '/index.html')
)

io.sockets.on('connection', (socket) ->
  socket.emit('news', { hello: 'world2' })
  socket.on('my other event', (data) ->
    console.log(data)
  )
)
