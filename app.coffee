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

App = require('./assets/main/js/classes.coffee')

io.sockets.on 'connection', (socket) ->
  socket.on 'new player', (data) ->
    player = data
    #add player to global collection
    App.players.push player

    #find game
    game = null
    for metagame in App.metagames
      if metagame.isAcceptingPlayers()
        game = metagame
        break

    if !game #still haven't found a game for them
      game = new App.Metagame
      game.serverInit(io)
      App.metagames.push game

    socket.emit 'enter metagame', {metagame_id: game.id}
