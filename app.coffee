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
    console.log("init: add client")
    roomId = guid()
    Server.rooms[roomId] = {client_id: socket.id, data: {}}
    socket.emit 'init: connected to room', room: roomId
    socket.join(roomId)

  socket.on 'init: add controller', (data) ->
    console.log("init: add controller")
    if data? and data.room and Server.rooms[data.room]
      # this is a controller connecting
      Server.rooms[data.room].controller_id = socket.id;
      socket.join data.room
      socket.broadcast.to(data.room, "room: controller connected")

      # subscribe to events for this room
      socket.join data.room
      socket.emit 'init: connected to room', room: data.room
      console.log 'init: connected to room'
    else
      socket.emit "init: invalid room ID"
      console.log 'init: invalid room ID'

  socket.on 'disconnect', =>
    console.log("CONNECTION DROPPED: removing #{socket.id} from rooms")
    for room_id, room of Server.rooms
      if room.client_id == socket.id
        room.client_id = null
        socket.broadcast.to room_id, "server: client disconnected"
      else if room.controller_id == socket.id
        room.controller_id = null
        socket.broadcast.to room_id, "server: controller disconnected"
      if room.client_id == null and room.controller_id == null
        Server.rooms.delete room_id   # delete zombie rooms