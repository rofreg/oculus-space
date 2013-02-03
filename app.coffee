express = require('express')
less    = require('less-middleware');
app     = express()
server  = require('http').createServer(app)
io      = require('socket.io').listen(server)

app.configure () ->
  app.use(less({
    src: __dirname + '/assets',
    dest   : __dirname + "/assets",
    compress: true,
    prefix : '/assets'
  }));
  app.use '/assets', express.static(__dirname + "/assets")

server.listen(80)

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

app.get '/favicon.ico', (req, res) ->
  res.sendfile(__dirname + '/assets/favicon.ico')

app.get '/:id', (req, res) ->
  console.log "Accessed URL: /#{req.params.id}"

App = require('./assets/main/js/classes.coffee')

io.sockets.on 'connection', (socket) ->
  socket.on 'new player', (data) ->

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
  socket.on 'disconnect', =>
    console.log("PLAYER DROPPED: removing #{socket.id} from all games")
    for metagame in App.metagames
      metagame.removePlayer(socket.id)
