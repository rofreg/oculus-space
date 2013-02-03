class App.Minigames.HotPotato extends App.Minigames.Default
  @NAME: 'HotPotato'
  @INSTRUCTIONS: "When the bomb comes to you, flick it towards one of your opponents. Don't get caught holding the bomb!"
  @TEMPLATES = "/assets/minigames/hot_potato/templates.js"
  @STYLESHEET = "/assets/minigames/hot_potato/styles.css"

  init: ->
    super
    if !App.Templates.HotPotato?
      $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
      $.getScript(this.constructor.TEMPLATES)

  start: =>
    this.el = $("<div>").attr("id":"hot-potato").addClass('active view')
    this.el.html _.template App.Templates.HotPotato.main_view, {
      players: this.players
    }
    $('body').append(this.el)
    setTimeout (=> this.el.find('.notice').fadeOut(250)), 850
    setTimeout (=> this.trueStart()), 1000

  trueStart: =>
    this.gameOn = true

    if (this.players.sort((p1, p2) => p1.name.localeCompare(p2.name))[0].id == App.player_id)
      for player in this.players
        player.hasBomb = false
      index = Math.floor(this.players.length * Math.random())
      this.players[index].hasBomb = true
      this.throwBomb(this.players[index].id)

    this.self = _.find this.players, (player) ->
      return player.id == App.player_id

    this.others = _.select this.players, (player) ->
      return player.id != App.player_id

    this.el.find('.person').bind "click", (e) =>
      console.log($(e.currentTarget).data('id'))
      if this.self.hasBomb and this.gameOn
        this.throwBomb($(e.currentTarget).data('id'))

    this.el.bind "touchstart", (e) =>
      this.touchstart = null

    this.el.bind "touchmove", (e) =>
      if !this.touchstart
        this.touchstart = e.originalEvent
      else
        this.touchend = e.originalEvent

    this.el.bind "touchend", (e) =>
      if this.self.hasBomb and this.gameOn and this.touchstart
        start = this.touchstart.pageX
        end = this.touchend.pageX
        console.log(this.touchstart)
        console.log(this.touchend)
        diff = end - start
        start = this.touchstart.pageY
        end = this.touchend.pageY
        ratio = (start - end) / diff

        console.log("diff: #{diff}")
        console.log("ratio: #{ratio}")

        if this.players.length == 1
          return
        else if this.players.length == 2
          this.throwBomb(this.others[0].id)
        else if this.players.length == 3
          if diff >= 0
            this.throwBomb(this.others[0].id)
          else
            this.throwBomb(this.others[1].id)
        else  # 4 players
          if Math.abs(ratio) > 4 or Math.abs(diff) < 50
            this.throwBomb(this.others[1].id)
          else if diff <= 0
            this.throwBomb(this.others[0].id)
          else
            this.throwBomb(this.others[2].id)

        this.touchstart = null
        this.touchend = null

    this.initializeClock()
    this.clock = setInterval (=> this.updateClock()), 1000

  initializeClock: =>
    this.el.find('.clock').text('10')

  updateClock: =>
    currentVal = parseInt(this.el.find('.clock').text())
    if currentVal <= 1
      this.el.find('.clock').text("BOOM")
      clearInterval(this.clock)
      this.endGame()
    else
      if currentVal <= 5
        this.el.find('.clock').css('color','#f00')
      this.el.find('.clock').text((currentVal-1))

  endGame: =>
    this.gameOn = false
    this.el.find('.bomb').css({background: "#b00"})

    setTimeout (=>
      loser = _.find this.players, (player) -> player.hasBomb
      this.el.find('.notice').text("#{loser.name} lost!").fadeIn()
      ), 1000
    setTimeout (=> this.gameover()), 3500

  throwBomb: (id) =>
    this.broadcast('hot potato: has bomb', {id: id})
    # this.setBombPlayer(id)
    # this.redrawBomb()
    console.log('transmitting throw to '+id)

  redrawBomb: =>
    $('.bomb').removeClass('you player_0 player_1 player_2')
    if this.self and this.self.hasBomb
      $('.bomb').addClass('you')
    else
      bomber = _.find this.players, (player) -> player.hasBomb
      if bomber
        $('.bomb').addClass("player_#{bomber.index}")

  setBombPlayer: (id) =>
    console.log("setting bomb player: #{id}")
    for player in this.players
      player.hasBomb = false
    for player in this.players
      if player.id == id
        player.hasBomb = true
        # ( =>
          # setTimeout (=> player.hasBomb = true), 250
        # )

  gameover: ->
    $(this.el).fadeOut()
    if this.self.hasBomb
      App.metagame.gameover(-10)
    else
      App.metagame.gameover(5)

  receiveBroadcast: (event, data, player_id) =>
    if player_id?
      if event == "hot potato: has bomb"
        console.log("received bomb transfer event")
        this.setBombPlayer data.id
        this.redrawBomb()

App.metagame.addMinigame App.Minigames.HotPotato

