Server = {}

class Server.Metagame

  constructor: (@id) ->

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    null

  allMinigames: [
    {
      'name': 'TapRace'
      'src': "/assets/minigames/tap_race.js"
    }
  ]

  minigames: [
    {
      'name': 'TapRace'
      'src': "/assets/minigames/tap_race.js"
    }
  ]

  init: (io) =>
    console.log "New metagame with id #{this.id}"
    this.players = []
    this.room = io.of("/#{@id}")
    this.room.on 'connection', (socket) =>
      socket.on 'players: player joining', this.addPlayer
      socket.on 'minigame: done loading', this.minigameDoneLoading
      socket.on 'minigame: gameover', this.gameover

  isAcceptingPlayers: =>
    true

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    return null

  minigameDoneLoading: (data) =>
    #set this player to ready
    for player in this.players
      if player.id == data.player.id
        player.ready = true
        break
    if this.allPlayersReady()
      this.start()

  addPlayer: (data) =>
    console.log '####################### PLAYER JOINING'
    this.players.push(data.player)
    this.room.emit 'players: list updated', this.players
    if true #this.players.length >= 2
      this.loadGame(0)

  allPlayersReady: => #server side check
    for player in this.players
      if !player.ready
        return false
    return true

  start: =>
    this.room.emit('minigame: start')

  loadGame: (index) =>
    this.currentMinigame = index
    for player in this.players
      player.ready = false
    this.room.emit 'minigame: load', {src: this.minigames[index].src}

  gameover: (data) =>
    this.getPlayer(data.player.id).score = data.score


module.exports = Server.Metagame
