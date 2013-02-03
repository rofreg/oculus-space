class App.Metagame
  @TEMPLATES = "/assets/metagames/default/templates/templates.js"
  @STYLESHEET = "/assets/metagames/default/css/metagame.css"

  constructor: (@id) ->

  getPlayer: (id) =>
    for player in this.players
      if player.id == id
        return player
    null

  minigames: []

  init: (io, name) =>
    $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
    $.getScript(this.constructor.TEMPLATES).done (script, textStatus) =>
      console.log "New metagame with id #{this.id}"
      # create Metagame <div>
      this.el = $("<div>").addClass('active view').attr("id","metagame").hide()
      this.el.html _.template(App.Metagame.Default.Templates.main_view)
      $('body').append(this.el)
      $('.active.view').removeClass('active').fadeOut()
      this.el.fadeIn()

      # connect to server and listen for players
      this.socket = io.connect("/#{@id}")

      # join the list of players
      this.socket.emit 'players: player joining', {name: name}

      # update the list of players/scores
      this.socket.on 'players: list updated', (players) =>
        this.players = players
        this.updateWaitingRoom()
        this.updateInstructions()
        this.updateScoreboard()
        this.currentMinigame.playersUpdated() if this.currentMinigame?

      # metagame
      this.socket.on 'metagame: start', this.metagameStart

      # minigames
      this.socket.on 'minigame: load', this.minigameLoad
      this.socket.on 'minigame: start', =>
        this.minigameCountdown()
      this.socket.on 'minigame: gameover', (data) =>
        this.players = data.players
        this.showResults()

      this.socket.on 'broadcast', this.receiveBroadcast
      this.socket.on 'proxyFetchReturn', this.proxyFetchReturn

  updateWaitingRoom: =>
    # render the metagame window
    this.el.find('#waiting_room').html(
      _.template(App.Metagame.Default.Templates.waiting_room,
      {players: this.players, metagame: this})
    )

    # start metagame by clicking "start"
    this.el.find('#waiting_room button').click =>
      if this.el.find('#waiting_room button').attr('disabled') != "disabled"
        if this.players.length < 1
          alert("You need at least two people to play!")
        else
          this.el.find('#waiting_room button').attr('disabled', 'disabled').text("Working...")
          this.socket.emit 'metagame: start'

  metagameStart: =>
    this.el.find('#intro').html(
      _.template(App.Metagame.Default.Templates.intro,
      {players: this.players})
    )
    this.el.find('#waiting_room').slideUp(500)
    # setTimeout((=> this.el.find('#intro').slideUp(500)), 3500)
    
  updateInstructions: =>
    # render the instructions screen
    if this.currentMinigame
      this.el.find('#pregame').html(_.template(App.Metagame.Default.Templates.pregame, {
        name: this.currentMinigame.constructor.NAME,
        instructions: this.currentMinigame.constructor.INSTRUCTIONS,
        players: this.players,
        ready: this.ready
      }))
      this.el.find('#pregame button').click =>
        if this.el.find('#pregame button').attr('disabled') != "disabled"
          this.el.find('#pregame button').attr('disabled', 'disabled').text("Waiting...")
          this.playerReady()

  updateScoreboard: =>
    # render the scoreboard screen
    this.el.find('#scoreboard').html(
      _.template(App.Metagame.Default.Templates.scoreboard,
      {players: this.sorted_players})
    )

  showScoreboard: =>
    this.updateScoreboard()
    this.el.find('#scoreboard').show()

  showResults: =>
    if !this.sorted_players
      this.sorted_players = this.players
    for player in this.players
      for sorted_player in this.sorted_players
        if sorted_player.id == player.id
          sorted_player.minigame_score = player.minigame_score
          break

    this.updateScoreboard()
    this.el.find('#scoreboard').show()
    setTimeout (=> this.showNextGameIntro()), 5500 + (this.players.length * 1000)
    for player, index in this.sorted_players
      (=>
        player.score += player.minigame_score
        temp = $("tr[data-id=#{player.id}] td.score span")
        score = player.score
        setTimeout (=> temp.text(score)), 3000 + index * 1000
      )()

    this.sorted_players = this.players.sort (s1, s2) =>
      s1.score <= s2.score

    top = 60
    setTimeout (=>
      top = 60
      $.each this.sorted_players, (index, player) =>
        $("#scoreboard tr[data-id=#{player.id}]").animate({
          position: 'absolute',
          top: top + 'px'
        }, 500)
        top += 60
      ), 3500 + (this.players.length * 1000)

  showNextGameIntro: =>
    this.el.find('#next_game').html(
      _.template(App.Metagame.Default.Templates.next_game, {
        players: this.players,
        currentMinigame: this.currentMinigame
      })
    ).show()
    this.el.find('#scoreboard').slideUp(500)
    setTimeout (=>
      this.el.find('#pregame').slideDown(500)
    ), 3000

  minigameCountdown: =>
    this.el.find('#countdown').html(_.template(App.Metagame.Default.Templates.countdown),{}).show()
    $('#backgrounds').fadeOut(3000)
    $('#overlay').fadeIn(3000)
    setTimeout (=> this.el.find('#countdown span').text("2")), 1000
    setTimeout (=> this.el.find('#countdown span').text("1")), 2000
    setTimeout (=> this.el.fadeOut(500)), 2500
    setTimeout (=>
        this.el.find('#countdown').hide()
        this.el.find('#pregame').hide()
      ), 3000
    setTimeout this.currentMinigame.start, 3000

  minigameLoad: (data) =>
    this.el.find(".next_game").text(data.minigame.name)
    this.el.find(".next_game").fadeIn(300)

    console.log("LOADING MINIGAME: #{data.minigame.name}")
    this.el.find('#instructions').show()
    if this.minigames[data.minigame.name]
      this.currentMinigame = new this.minigames[data.minigame.name]
      this.currentMinigame.init()
      this.minigameShowInstructions()
      setTimeout((=> this.el.find('#intro').slideUp(500)), 2000)
    else
      $.getScript(data.minigame.src).done (script, textStatus) =>
        this.currentMinigame = new this.minigames[data.minigame.name]
        this.currentMinigame.init()
        this.minigameShowInstructions()
        setTimeout((=> this.el.find('#intro').slideUp(500)), 2000)

  minigameShowInstructions: =>
    this.updateInstructions()
    # this.el.find('#pregame').slideDown()

  addMinigame: (minigame) =>
    this.minigames[minigame.NAME] = minigame

  playerReady: =>
    this.ready = true
    this.socket.emit 'metagame: player ready'
      
  gameover: (score) ->
    this.ready = false
    $('#backgrounds').fadeIn(1000)
    $('#overlay').fadeOut(1000)
    this.socket.emit 'minigame: gameover',
      score: score
    this.el.fadeIn()
    # TODO: better handling if there's a delay (e.g. show a 'loading...' toast)

  sendBroadcast: (event, data) ->
    this.socket.emit 'broadcast',
      _event: event
      _data: data

  receiveBroadcast: (data) =>
    if this.currentMinigame?
      this.currentMinigame.receiveBroadcast data._event, data._data, data._player_id

  proxyFetch: (url) =>
    this.socket.emit 'proxyFetch', {url: url}

  proxyFetchReturn: (data) =>
    console.log data
    if this.currentMinigame?
      this.currentMinigame.proxyFetchReturn data
    
