class App.Metagame

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

  init: (io, name) =>
    console.log "New metagame with id #{this.id}"
    # create Metagame <div>
    this.el = $("<div>").addClass('active view').attr("id","metagame")
    $('.active.view').removeClass('active').hide()
    $('body').append(this.el)

    # connect to server and listen for players
    this.socket = io.connect("/#{@id}")
    this.socket.emit 'players: player joining', {name: name}
    console.log 'sending JOINING'

    this.socket.on 'players: list updated', (players) =>
      this.players = players
      this.drawPlayerList()

    this.socket.on 'minigame: load', this.minigameLoad

    this.socket.on 'minigame: start', =>
      this.minigames[0].instance.start()

  drawPlayerList: =>
    console.log this
    console.log this.players
    this.el.html(JSON.stringify(this.players))

  minigameLoad: (data) =>
    #display loading.gif
    $.getScript(data.src).done (script, textStatus) =>
      #remove loading.gif
      this.ready = true
      this.socket.emit 'minigame: done loading'

  gameover: (minigame) ->
    this.socket.emit 'minigame: gameover',
      score: minigame.score
    this.drawPlayerList()
    

