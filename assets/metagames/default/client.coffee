App or= {}
App.Metagames or= {}

class App.Metagames.DefaultClient extends App.Metagames.Default

  init: (io) ->
    # create Metagame <div>
    this.el = $("<div>").addClass('active view').attr("id","metagame")
    $('.active.view').removeClass('active').hide()
    $('body').append(this.el)

    # connect to server and listen for players
    this.socket = io.connect("/#{@id}")
    this.socket.emit 'players: player joining', {player: App.player}

    this.socket.on 'players: list updated', (players) =>
      this.players = players
      this.drawPlayerList()

    this.socket.on 'minigame: load', this.minigameLoad

    this.socket.on 'minigame: start', ->
      App.minigames[0].start()

  drawPlayerList: =>
    console.log this
    console.log this.players
    this.el.html(JSON.stringify(this.players))

  minigameLoad: (data) =>
    #display loading.gif
    $.getScript(data.src).done (script, textStatus) =>
      #remove loading.gif
      this.ready = true
      this.socket.emit 'minigame: done loading', {player: App.player}

  gameover: (minigame) ->
    this.getPlayer(App.player.id).score = minigame.score
    this.socket.emit 'minigame: gameover',
      player: App.player
      score: minigame.score
    this.drawPlayerList()
    

if module?
  module.exports = App.Metagames.Default
else
  window.App = App
