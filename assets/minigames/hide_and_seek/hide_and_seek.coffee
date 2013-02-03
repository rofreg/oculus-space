class App.Minigames.HideAndSeek extends App.Minigames.Default

  @NAME: 'HideAndSeek'
  @INSTRUCTIONS: "HideAndSeek is a game about avoiding the intertubes! Avoid the randomly generated memes, and try to get outside! You're either a seeker or a hider in this one."
  @TEMPLATES = "/assets/minigames/hide_and_seek/templates.js"
  @STYLESHEET = "/assets/minigames/hide_and_seek/styles.css"

  init: =>
    if !App.Templates.HideAndSeek?
      $('head').append("<link rel='stylesheet' href='#{this.constructor.STYLESHEET}'>")
      $.getScript(this.constructor.TEMPLATES)
    this.grid = [[], [], [], []]
    this.proxyFetch("http://version1.api.memegenerator.net/Instances_Select_ByPopular?languageCode=en&pageIndex=0&pageSize=16&days=7")
    this.forests = ["/assets/minigames/hide_and_seek/images/forest1.jpg",
                    "/assets/minigames/hide_and_seek/images/forest2.jpg",
                    "/assets/minigames/hide_and_seek/images/forest3.jpg"]
    super

  start: =>
    #initialize grid
    for x in [0..3]
      for y in [0..3]
        this.grid[x][y] = { name: "#{x}, #{y}", players: [] }

    this.player = this.getCurrentPlayer()
    this.el = $(_.template(App.Templates.HideAndSeek.main)())
    $("body").append this.el

    #figure out if I am seeker
    for player in this.players
      player.hiding = true
    this.players.sort (a,b) ->
      return a.name.localeCompare(b.name)
    this.players[0].discovered = true
    if this.player == this.players[0]
      this.player.seeking = true
      this.player.hiding = false
      this.player.discovered = true

    if this.player.seeking
      this.el.html _.template App.Templates.HideAndSeek.seekerIntro
    else
      this.player.hiding = true
      this.player.hidden = false
      this.el.html _.template App.Templates.HideAndSeek.hiderIntro
      this.el.find(".hider-confirm").bind "touchstart click", =>
        this.renderGrid()

  randomlyPopulate: ->
    for i in [0..2]
      this.players.push
        location:
          x: Math.floor(Math.random() * 4)
          y: Math.floor(Math.random() * 4)
        id: Math.floor(Math.random() * 500)
        name: Math.floor(Math.random() * 500)
        hiding: false
        hidden: true
        color: ["black", "red", "green"][i]
    this.renderGrid()

  renderGrid: ->
    #rebuild this.grid
    for x in [0..3]
      for y in [0..3]
        this.grid[x][y].players = []

    for player in this.players
      if player.location
        this.grid[player.location.x][player.location.y].players.push player

    #draw grid
    this.el.html _.template App.Templates.HideAndSeek.grid,
      grid: this.grid
      player: this.player
      memes: this.memes
      forests: this.forests

    #touch events for grid, based on player states
    if this.player.hiding
      that = this
      this.el.find(".HAS-cell").bind "touchstart click", ->
        that.hideInCell($(this).closest('.HAS-cell'))
    else if this.player.seeking
      that = this
      this.el.find(".HAS-cell").bind "touchstart click", ->
        cell = $(this).closest('.HAS-cell')
        x = parseInt(cell.attr('data-x'))
        y = parseInt(cell.attr('data-y'))
        that.inspectCell(x, y)
        that.broadcast "board: inspect", { location : {x:x, y:y}}

  hideInCell: (cell) ->
    this.player.hiding = false
    this.player.hidden = true
    this.player.location = {x: cell.attr('data-x'), y: cell.attr('data-y')}
    this.broadcast "player: hidden", { location : this.player.location }
    this.renderGrid()
      
  inspectCell: (x, y) ->
    cell = this.grid[x][y]
    cell.inspected = true
    if cell.players.length
      for player in cell.players
        player.discovered = true
    this.renderGrid()
    if this.allPlayersDiscovered()
      console.log 'gameover'
      this.gameover()

  allPlayersDiscovered: ->
    for player in this.players
      if !player.discovered
        return false
    return true

  receiveBroadcast: (event, data, player_id) =>
    if player_id?
      if event == 'player: hidden'
        this.getPlayer(player_id).location = data.location
        this.getPlayer(player_id).hiding = false
        if this.player.seeking
          if this.allHidersHidden()
            this.renderGrid()
        else
          this.renderGrid()
      else if event == "board: inspect"
        this.inspectCell data.location.x, data.location.y

  allHidersHidden: ->
    for player in this.players
      if player.hiding
        return false
    return true

  proxyFetchReturn: (json) ->
    this.memes = _.map json.body.result, (item) -> item.instanceImageUrl
    console.log this.memes

  gameover: ->
    this.el.remove()
    if this.player.seeker
      App.metagame.gameover 10
    else
      App.metagame.gameover 0


App.metagame.addMinigame App.Minigames.HideAndSeek
