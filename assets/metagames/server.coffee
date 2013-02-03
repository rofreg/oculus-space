Server = {}

class Server.Metagame

  constructor: (@id) ->
  colors: [
    '#ff0000', #red
    '#ff6600', #orange
    '#ffe500', #yellow
    '#00cc00', #green
    '#0033cc', #blue
    '#9900cc', #purple
    '#ff00cc', #pink
  ]

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    null

  minigames: [
    {
      'name': 'TapRace'
      'src': "/assets/minigames/tap_race.js"
    }
  ]

  init: (io) =>
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on 'connection', (socket) =>
      socket.on 'players: player joining', (data) => this.addPlayer(data.name, socket.id)
      socket.on 'metagame: player ready', => this.playerReady(socket.id)
      socket.on 'minigame: gameover', (data) => this.gameover(data.score, socket.id)

  addPlayer: (name, id) =>
    this.colorCount = 0 if not this.colorCount
    this.players.push({name: name, id: id, color: this.colors[this.colorCount++ % this.colors.length], score: 0})
    this.sendPlayerList()

    if this.readyToStart()
      this.loadRandomGame()
  
  readyToStart: ->
    this.players.length > 1 and this.allPlayersNotInGame()

  removePlayer: (id) =>
    for index, player of this.players
      if (player.id == id)
        this.players.splice(index, 1)
        this.sendPlayerList()

  sendPlayerList: =>
    this.room.emit 'players: list updated', _.filter(this.players, (player) -> !player.in_game)

  isAcceptingPlayers: =>
    true

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    return null

  playerReady: (id) =>
    #set this player to ready
    this.getPlayer(id).ready = true
    if this.allPlayersReady()
      this.start()

  allPlayersNotInGame: =>
    for player in this.players
      if player.in_game
        return false
    return true

  allPlayersReady: =>
    for player in this.players
      if !player.ready
        return false
    return true

  start: =>
    for player in this.players
      player.in_game = true
    this.room.emit('minigame: start')

  loadRandomGame: =>
    this.loadGame(Math.floor(this.minigames.length * Math.random()))
    
  loadGame: (index) =>
    this.currentMinigameIndex = index
    for player in this.players
      player.ready = false
    this.room.emit 'minigame: load', {minigame: this.minigames[index]}

  gameover: (score, id) =>
    this.getPlayer(id).score = score
    this.getPlayer(id).in_game = false
    this.sendPlayerList()

    if this.readyToStart()
      this.loadRandomGame()
  

module.exports = Server.Metagame
