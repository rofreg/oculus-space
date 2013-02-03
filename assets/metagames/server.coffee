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
    # {
    #   'name': 'TapRace'
    #   'src': "/assets/minigames/tap_race/tap_race.js"
    # },
    # {
    #   'name': 'DoubleTapRace'
    #   'src': "/assets/minigames/double_tap_race/double_tap_race.js"
    # },
    {
      'name': 'HotPotato'
      'src': "/assets/minigames/hot_potato/hot_potato.js"
    }
  ]

  init: (io) =>
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on 'connection', (socket) =>
      socket.on 'players: player joining', (data) => this.addPlayer(data.name, socket.id)
      socket.on 'metagame: start', this.startMetagame
      socket.on 'metagame: player ready', => this.playerReady(socket.id)
      socket.on 'minigame: gameover', (data) => this.gameover(data.score, socket.id)
      socket.on 'players: refresh', this.sendPlayerList
      socket.on 'broadcast', (data) =>
        data._player_id = socket.id
        this.room.emit('broadcast', data)

  addPlayer: (name, id) =>
    this.colorCount = 0 if not this.colorCount
    this.players.push({name: name, id: id, color: this.colors[this.colorCount++ % this.colors.length], score: 0})
    this.sendPlayerList()
  
  startMetagame: =>
    if this.players.length >= 1
      console.log('STARTING METAGAME!')
      this.gameStarted = true
      this.room.emit 'metagame: start'
      this.loadRandomGame()

  readyToStart: ->
    this.players.length >= 1 and this.allPlayersNotInGame()

  removePlayer: (id) =>
    for index, player of this.players
      if (player.id == id)
        this.players.splice(index, 1)
        this.sendPlayerList()

  sendPlayerList: =>
    this.room.emit 'players: list updated', this.players

  isAcceptingPlayers: =>
    this.players.length < 4 && !this.gameStarted

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    return null

  playerReady: (id) =>
    #set this player to ready
    this.getPlayer(id).ready = true
    this.sendPlayerList()
    if this.allPlayersReady()
      this.startMinigame()

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

  startMinigame: =>
    for player in this.players
      player.in_game = true
      player.ready = false
      player.minigame_score = 0
    this.room.emit('minigame: start')

  loadRandomGame: =>
    this.loadGame(Math.floor(this.minigames.length * Math.random()))
    
  loadGame: (index) =>
    this.currentMinigameIndex = index
    for player in this.players
      player.ready = false
    console.log("LOADING GAME: #{this.minigames[index]['name']}")
    this.room.emit 'minigame: load', {minigame: this.minigames[index]}

  gameover: (score, id) =>
    if !score
      score = 0
    this.getPlayer(id).minigame_score = score
    this.getPlayer(id).in_game = false
    this.sendPlayerList()

    if this.readyToStart()
      this.room.emit 'minigame: gameover', {players: this.players}
      for player in this.players
        player.score += player.minigame_score
      this.loadRandomGame()
  

module.exports = Server.Metagame
