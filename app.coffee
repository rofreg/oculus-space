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

server.listen(80)

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

app.get '/favicon.ico', (req, res) ->
  res.sendfile(__dirname + '/assets/favicon.ico')

app.get '/apple-touch-icon-114x114-precomposed.png', (req, res) ->
  res.sendfile(__dirname + '/assets/apple-touch-icon-precomposed.png')

app.get '/apple-touch-icon-precomposed.png', (req, res) ->
  res.sendfile(__dirname + '/assets/apple-touch-icon-precomposed.png')

app.get '/:id', (req, res) ->
  res.sendfile(__dirname + '/index.html')
  console.log "Accessed URL: /#{req.params.id}"

Server =
  metagames: []
  metagame_index: 0

Server.Metagame = require('./assets/metagames/server.coffee')

io.sockets.on 'connection', (socket) ->
  socket.emit 'player: your id', {id: socket.id}

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

  socket.on 'disconnect', =>
    console.log("PLAYER DROPPED: removing #{socket.id} from all games")
    for metagame in Server.metagames
      metagame.removePlayer(socket.id)
