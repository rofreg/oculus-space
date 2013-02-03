class App.Minigames.DoubleTapRace extends App.Minigames.Default
  @NAME: 'DoubleTapRace'
  @INSTRUCTIONS: 'DoubleTapRace is a fun game. Click the buttons to move legs.'
  @TEMPLATES: "/assets/minigames/double_tap_race/templates/templates.js"
  @STYLESHEET = "/assets/minigames/double_tap_race/css/double_tap_race.css"

  init: ->
    super

    this.dist= 0
    _.each this.players, (player) -> player.dist = 0

    $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
    $.getScript(this.constructor.TEMPLATES).done (script, textStatus) =>
      # create Minigame <div>
      this.el = $("<div>").addClass('active view').attr("id","double-tap-race-minigame")
      this.el.html _.template App.Minigames.DoubleTapRace.Templates.main_view
      this.el.find(".progress").html _.template App.Minigames.DoubleTapRace.Templates.player_view, {players: this.players}


  getPlayerRep:  (id) =>
    for player, i in this.players
      if player.id == id
        return $('.runner')[i]
    []


  start: =>
    $('body').append(this.el)
    this.render()

    that = this
    this.el.find(".btn").bind('click', ->
      if $(this).hasClass "active"
        $(this).siblings(".btn").addClass "active"
        $(this).removeClass "active"
        that.dist+= 10
        that.broadcast('player: scored', {dist: that.dist})
        that.render()
    )
    this.el.find(".btn").bind('touchstart', (e) ->
      e.preventDefault()
      if $(this).hasClass "active"
        $(this).siblings(".btn").addClass "active"
        $(this).removeClass "active"
        that.dist+= 10
        that.broadcast('player: scored', {dist: that.dist})
        that.render()
    )

  animateFeet: (rep) =>
      console.log rep
      $left = $($(rep).find('.left-foot'))
      $right = $($(rep).find('.right-foot'))
      if parseInt($left.css('left')) == 10
        $left.css('left', '30px')
        $right.css('left', '10px')
      else
        $left.css('left', '10px')
        $right.css('left', '30px')

  render: =>
    $('.score').text 'Distance = ' + this.dist

  gameover: =>
    App.metagame.gameover(this.dist)
    this.el.fadeOut()

  receiveBroadcast: (event, data, player_id) =>
    if player_id?
      for player in this.players
        if player.id == player_id
          player.dist = data.dist
          $(this.getPlayerRep(player_id)).css 'left', player.dist + 20;
          this.animateFeet(this.getPlayerRep(player_id))
          this.gameover() if player.dist + 50 == parseInt(this.el.css('width'))
          this.render()
          break

App.metagame.addMinigame App.Minigames.DoubleTapRace
