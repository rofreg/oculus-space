class App.Minigames.TapRace extends App.Minigames.Default
  name: 'TapRace'

  start: =>
    this.score = 0
    $(".view").html("<div class='minigame' style='width:100%; height:100%;'></div>")
    this.el = $(".minigame")
    this.el.append("<a href='#' class='btn'>Click me!</a>")
    this.el.append("<div class='score'>0</div>")
    this.el.find(".btn").bind 'click', =>
      this.score++
      this.render()
    setTimeout(this.gameover, 5000)

  render: =>
    $('.score').text(this.score)


  gameover: =>
    App.metagame.gameover(this)

for minigame in App.metagame.minigames
  if minigame.name == 'TapRace'
    minigame.instance = new App.Minigames.TapRace
