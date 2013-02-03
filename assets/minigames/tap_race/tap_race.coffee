class App.Minigames.TapRace extends App.Minigames.Default
  @NAME: 'TapRace'
  @INSTRUCTIONS: 'TapRace is a fun game. Click link, plz.'
  @TEMPLATES = "/assets/minigames/tap_race/templates.js"
  @STYLESHEET = "/assets/minigames/tap_race/styles.css"

  init: ->
    super
    Array::shuffle = -> @sort -> 0.5 - Math.random()

    if !App.Templates.TapRace?
      $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
      $.getScript(this.constructor.TEMPLATES)

  start: =>
    this.currentNumber = 1
    this.numbers = [1..16].shuffle()
    this.startTime = new Date
    for player in this.players
      player.currentNumber = 0

    this.el = $("<div>").attr("id":"tap-race-minigame")
    this.el.html _.template App.Templates.TapRace.main_view

    numbers = this.numbers
    tds = this.el.find("#tap-board td").each (i) ->
      $(this).text(numbers[i])

    this.render()
    $('body').append(this.el)
    that = this
    this.el.find("#tap-board td").bind "touchstart click", ->
      if parseInt($(this).text()) == that.currentNumber
        that.broadcast('player: scored', {number: that.currentNumber})
        that.currentNumber++
        $(this).text('')
        if that.currentNumber > 3#16
          that.done()

  render: ->
    this.el.find("#tap-race-players").html _.template App.Templates.TapRace.players_view,
      players: this.players
      currentPlayerId: App.player_id

  done: ->
    #set self to done
    for player in this.players
      if player.id == App.player_id
        player.done = true

    this.endTime = new Date
    this.time = this.endTime - this.startTime
    this.broadcast('player: done', {time: this.time})
    half = this.el.find(".top-half")
    half.find("table").fadeOut 500, =>
      elem = _.template App.Templates.TapRace.done,
        time: this.time / 1000
      elem = $(elem)
      elem.hide()
      half.html elem
      elem.fadeIn 500

  gameover: ->
    $(this.el).fadeOut()
    App.metagame.gameover(this.minigame_score)

  receiveBroadcast: (event, data, player_id) ->
    if player_id?
      if event == 'player: scored'
        for player in this.players
          if player.id == player_id
            table = this.el.find("#tap-race-players #score-table-#{player_id}")
            while data.number > player.currentNumber
              tds = table.find("td").not(".no-background")
              rand = Math.floor(Math.random() * tds.length)
              tds.eq(Math.floor(Math.random() * tds.length)).addClass('no-background')
              player.currentNumber++
              break
      else if event == 'player: done'
        for player in this.players
          if player.id == player_id
            player.done = true
            player.time = data.time
            holder = this.el.find("#score-table-holder-#{player_id}")
            holder.find("table").fadeOut 500, =>
              elem = _.template App.Templates.TapRace.other_done,
                time: data.time / 1000
              elem = $(elem)
              elem.hide()
              holder.html elem
              elem.fadeIn 500
        if this.allPlayersDone()
          setTimeout((=> this.calculateScores()), 3000)

  allPlayersDone: ->
    for player in this.players
      if !player.done
        return false
    return true
          
  sortPlayers: ->
    this.players.sort (a,b) ->
      return a.time - b.time

  calculateScores: ->
    this.sortPlayers()
    alert(JSON.stringify(this.players))

    this.el.find(".top-half > div").fadeOut 500
    this.el.find(".score-table-holder > div").fadeOut 500

    setTimeout (=> this.fillSpots()), 500
    setTimeout (=> this.gameover()), 2500

  fillSpots: ->
    for player, index in this.players
      player.spot = index + 1
      player.minigame_score = 10 if player.spot == 1
      player.minigame_score = 5  if player.spot == 2
      player.minigame_score = 3  if player.spot == 3
      player.minigame_score = 1  if player.spot == 4
      #console.log player
      #console.log player.spot
      #console.log player.minigame_score
      if player.id == App.player_id
        this.minigame_score = player.minigame_score
        half = this.el.find(".top-half")
        elem = _.template App.Templates.TapRace.final,
          spot: player.spot
        elem = $(elem)
        elem.hide()
        half.html elem
        elem.fadeIn 500
      else
        holder = this.el.find("#score-table-holder-#{player.id}")
        elem = _.template App.Templates.TapRace.final,
          spot: player.spot
        elem = $(elem)
        elem.hide()
        holder.html elem
        elem.fadeIn 500

App.metagame.addMinigame App.Minigames.TapRace

