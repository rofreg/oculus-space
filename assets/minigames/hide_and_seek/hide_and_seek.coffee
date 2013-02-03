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
    this.taunts = ["more t00bs for you!", "get off that damn computer!", "a sad, sad, habit..."]
    super

  start: =>
    #initialize grid
    for x in [0..3]
      for y in [0..3]
        this.grid[x][y] = { name: "#{x}, #{y}", players: [] }

    this.el = $(_.template(App.Templates.HideAndSeek.main)())
    $("body").append this.el

    #figure out if I am seeker
    for player in this.players
      player.hider = true
      player.hiddenYet = false

    this.players.sort (a,b) ->
      return a.id.localeCompare(b.id)

    this.players[0].seeker = true
    this.players[0].hider = false
    this.player = this.getCurrentPlayer()
    
    if this.player.seeker
      this.el.html _.template App.Templates.HideAndSeek.seekerIntro
    else
      this.el.html _.template App.Templates.HideAndSeek.hiderIntro
      this.el.find(".confirm").bind "touchstart click", =>
        this.renderGrid()

  notify: (string) ->
    this.el.find(".notif").html(string)

  randomlyPopulate: ->
    for i in [0..2]
      this.players.push
        location:
          x: Math.floor(Math.random() * 4)
          y: Math.floor(Math.random() * 4)
        id: Math.floor(Math.random() * 500)
        name: Math.floor(Math.random() * 500)
        hider: true
        hiddenYet: true
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
    if this.player.hider and !this.player.hiddenYet
      that = this
      this.el.find(".HAS-cell").bind "touchstart click", ->
        that.hideInCell($(this).closest('.HAS-cell'))
    else if this.player.seeker
      that = this
      this.el.find(".HAS-cell").bind "touchstart click", ->
        cell = $(this).closest('.HAS-cell')
        x = parseInt(cell.attr('data-x'))
        y = parseInt(cell.attr('data-y'))
        that.inspectCell(x, y)
        that.broadcast "board: inspect", { location : {x:x, y:y}}

  hideInCell: (cell) ->
    this.player.hiddenYet = true
    this.player.location = {x: cell.attr('data-x'), y: cell.attr('data-y')}
    this.broadcast "player: hidden", { location : this.player.location }
    this.renderGrid()
      
  inspectCell: (x, y) ->
    cell = this.grid[x][y]
    cell.inspected = true
    this.renderGrid()
    if this.allPlayersDiscovered()
      this.gameover()
    if cell.players.length
      this.notify("#{cell.players[0].name} bit the dust!")
    else if Math.floor Math.random() < 0.5
      this.notify(this.taunts[Math.floor(Math.random()*this.taunts.length)])

  allPlayersDiscovered: ->
    for player in this.players
      if player.hider and !this.grid[player.location.x][player.location.y].inspected
        return false
    return true

  receiveBroadcast: (event, data, player_id) =>
    if player_id?
      if event == 'player: hidden'
        player = this.getPlayer(player_id)
        player.location = data.location
        player.hiddenYet = true
        if this.player.seeker
          if this.allHidersHidden()
            this.seekerReady()
        else if this.player.hiddenYet
          this.renderGrid()
      else if event == "board: inspect"
        this.inspectCell data.location.x, data.location.y

  seekerReady: ->
    this.el.find(".explain").text("Ready to go!")
    this.el.find(".confirm").show().bind "touchstart click", =>
      this.renderGrid()
      this.el.find(".notif").text("Start searching!")

  allHidersHidden: ->
    for player in this.players
      if player.hider and !player.hiddenYet
        return false
    return true

  proxyFetchReturn: (json) ->
    this.memes = _.map json.body.result, (item) -> item.instanceImageUrl

  gameover: ->
    inspected = 0
    for x in [0..3]
      for y in [0..3]
        if this.grid[x][y].inspected
          inspected++

    this.notify("Exposed! In only #{inspected} shots")
    setTimeout((=>
      this.el.fadeOut 500, =>
        if this.player.seeker
          App.metagame.gameover 16 - inspected
        else
          App.metagame.gameover inspected
    ), 2000)


App.metagame.addMinigame App.Minigames.HideAndSeek
