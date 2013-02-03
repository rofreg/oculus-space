class App.Minigames.DoubleTapRace extends App.Minigames.Default
  @NAME: 'DoubleTapRace'
  @INSTRUCTIONS: 'DoubleTapRace is a fun game. Click the buttons to move legs.'
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
    console.log "click count: " + this.clickCount
    if this.clickCount % 15 == 0
      $('.score').text this.inspirations[Math.floor(this.inspirations.length * Math.random())]

  gameover: =>
    $(this.el).fadeOut()
    $('#double-tap-race-minigame').remove()
    App.metagame.gameover(this.dist)

  receiveBroadcast: (event, data, player_id) =>
    if player_id?
      for player in this.players
        if player.id == player_id
          player.dist = data.dist
          $(this.getPlayerRep(player_id)).css 'left', player.dist + 20;
          this.animateFeet(this.getPlayerRep(player_id))
          this.gameover() if player.dist + 50 == 560
          this.render()
          break

App.metagame.addMinigame App.Minigames.DoubleTapRace
