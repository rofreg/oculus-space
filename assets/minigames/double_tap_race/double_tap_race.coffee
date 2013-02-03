class App.Minigames.DoubleTapRace extends App.Minigames.Default
  @NAME: 'DoubleTapRace'
  @INSTRUCTIONS: "DoubleTapRace is a race to the finish. Tap the buttons to move your player's legs so they can run. First one to the finish line wins!"
  @TEMPLATES: "/assets/minigames/double_tap_race/templates/templates.js"
  @STYLESHEET = "/assets/minigames/double_tap_race/css/double_tap_race.css"

  inspirations: [
    "You can do it!",
    "Show 'em who's boss!",
    "Go get 'em, tiger!",
    "Look at those little legs go!",
    "Run, Forrest!"
  ]

  init: ->
    super

    if !App.Minigames.DoubleTapRace.Templates?
      $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
      $.getScript(this.constructor.TEMPLATES)

  start: =>
    this.clickCount = 0
    this.dist= 0
    _.each this.players, (player) -> player.dist = 0

    this.el = $("<div>").addClass('active view').attr("id","double-tap-race-minigame")
    this.el.html _.template App.Minigames.DoubleTapRace.Templates.main_view
    this.el.find(".progress").html _.template App.Minigames.DoubleTapRace.Templates.player_view, {players: this.players}
    $('body').append(this.el)
    this.render()

    that = this
    this.el.find(".btn").bind('click', ->
      that.clickCount++
      if $(this).hasClass "active"
        $(this).siblings(".btn").addClass "active"
        $(this).removeClass "active"
        that.dist+= 5
        that.broadcast('player: scored', {dist: that.dist})
        that.render()
    )
    this.el.find(".btn").bind('touchstart', (e) ->
      e.preventDefault()
      that.clickCount++;
      if $(this).hasClass "active"
        $(this).siblings(".btn").addClass "active"
        $(this).removeClass "active"
        that.dist+= 5
        that.broadcast('player: scored', {dist: that.dist})
        that.render()
    )
    this.raceCountdown()

  raceCountdown: =>
    setTimeout (=> $('.score').text("Set")), 2000
    setTimeout (=> $('.score').text("GOOOOOOO!")), 4000
    setTimeout this.raceStart, 4000

  raceStart: =>
    $(this.el.find('.btn')[0]).addClass('active')


  getPlayerRep:  (id) =>
    for player, i in this.players
      if player.id == id
        return $('.runner')[i]
    []

  animateFeet: (rep) =>
      $left = $($(rep).find('.left-foot'))
      $right = $($(rep).find('.right-foot'))
      if parseInt($left.css('left')) == 10
        $left.css('left', '30px')
        $right.css('left', '10px')
      else
        $left.css('left', '10px')
        $right.css('left', '30px')

  render: =>
    if this.clickCount > 0 && this.clickCount % 15 == 0
      this.clickCount++
      $('.score').text this.inspirations[Math.floor(this.inspirations.length * Math.random())]


  sortPlayers: ->
    this.players.sort (a, b) ->
      return b.dist - a.dist

  updatePlayers: ->
    this.sortPlayers()
    for player, index in this.players
      player.spot = index + 1
      player.minigame_score = 10 if player.spot == 1
      player.minigame_score = 5  if player.spot == 2
      player.minigame_score = 3  if player.spot == 3
      player.minigame_score = 1  if player.spot == 4
      if player.id == App.player_id
        this.minigame_score = player.minigame_score

  gameover: =>
    $(this.el).fadeOut()
    $('#double-tap-race-minigame').remove()
    this.updatePlayers()
    App.metagame.gameover(this.minigame_score)

  receiveBroadcast: (event, data, player_id) =>
    if player_id?
      for player in this.players
        if player.id == player_id
          player.dist = data.dist
          $(this.getPlayerRep(player_id)).css 'left', player.dist + 20;
          this.animateFeet(this.getPlayerRep(player_id))
          this.gameover() if player.dist + 50 == 500
          this.render()
          break

App.metagame.addMinigame App.Minigames.DoubleTapRace
