class App.Minigames.Default
  constructor: ->
    this.id = Math.random().toString(36).substring(2,8)  # random hex id

  init: ->
    this.players = []
    for player in App.metagame.players
      new_player = jQuery.extend(true, {}, player)
      this.players.push new_player

  playersUpdated: ->
    
  receiveBroadcast: (event, data, player_id) ->

  broadcast: (event, data = {}) ->
    App.metagame.sendBroadcast(event, data)

  getPlayer: (id) ->
    for player in this.players
      if player.id == id
        return player
    return null

  getCurrentPlayer: ->
    this.getPlayer(App.player_id)

  gameover: ->
    App.metagame.gameover Math.floor Math.random() * 10

  proxyFetch: (url) ->
    App.metagame.proxyFetch url

  proxyFetchReturn: (data) ->
    console.log JSON.parse data
