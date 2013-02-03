express = require('express')
app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

app.configure () ->
  app.use '/assets', express.static(__dirname + "/assets")

server.listen(80)

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

app.get '/:id', (req, res) ->
  console.log "Connecting to game #{req.params.id}"

Server =
  metagames: []
  metagame_index: 0

Server.Metagame = require('./assets/metagames/server.coffee')

io.sockets.on 'connection', (socket) ->
  socket.on 'server: new player', (data) ->
    #find game
    game = null
    for metagame in Server.metagames
      if metagame.isAcceptingPlayers()
        game = metagame
        break

    if !game #still haven't found a game for them
      game = new Server.Metagame(Server.metagame_index++)
      game.init(io)
      Server.metagames.push game

    socket.emit 'server: enter metagame', {metagame_id: game.id}
