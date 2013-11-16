express = require('express')
less    = require('less-middleware');
app     = express()
server  = require('http').createServer(app)
io      = require('socket.io').listen(server)

app.configure () ->
  app.use(less({
    src: __dirname + '/assets'
    dest   : __dirname + "/assets"
    compress: true
    prefix : '/assets'
  }))
  app.use '/assets', express.static(__dirname + "/assets")

server.listen(8080)
io.set 'log level', 1

app.get '/', (req, res) ->
  ua = req.header('user-agent')
  if /mobile/i.test(ua)
    res.sendfile(__dirname + '/mobile.html')
  else
    res.sendfile(__dirname + '/index.html')

app.get '/mobile', (req, res) ->
  res.sendfile(__dirname + '/mobile.html')

Server =
  rooms: {}


guid = () ->
  ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(Math.floor(Math.random()*26)) for [1..4]).join("")


io.sockets.on 'connection', (socket) ->
  socket.on 'init: add client', (data) ->
    roomId = guid()
    console.log "#{roomId}: starting room"
    console.log "#{roomId}: adding client #{socket.id}"
    Server.rooms[roomId] = {client_id: socket.id, data: {}}
    socket.emit 'init: connected to room', room: roomId
    socket.join roomId

  socket.on 'init: add controller', (data) ->
    # if no room ID submitted, just take the first room (if available)
    if not data? and Object.keys(Server.rooms).length > 0
      roomId = Object.keys(Server.rooms)[0]
      data = {}
      if roomId and not Server.rooms[roomId].controller_id
        data.room = Object.keys(Server.rooms)[0]

    if data? and data.room and Server.rooms[data.room]
      # this is a controller connecting
      console.log "#{data.room}: adding controller #{socket.id}"
      Server.rooms[data.room].controller_id = socket.id;
      socket.join data.room

      # subscribe to events for this room
      socket.emit 'init: connected to room', room: data.room
    else
      socket.emit "init: invalid room ID"

  socket.on 'broadcast', (data) ->
    socket.broadcast.to(data.room).emit(data.event, data.data)

  socket.on 'disconnect', =>
    console.log("Connection lost for socket #{socket.id}")
    for room_id, room of Server.rooms
      if room.client_id == socket.id
        room.client_id = null
        socket.broadcast.to(room_id).emit "server: client disconnected"
      else if room.controller_id == socket.id
        room.controller_id = null
        socket.broadcast.to(room_id).emit "server: controller disconnected"
      if not room.client_id and not room.controller_id
        console.log "Killing room #{room_id}"
        delete Server.rooms[room_id]   # delete zombie rooms