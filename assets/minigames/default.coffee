class TapRace extends App.Minigame
  start: =>
    this.score = 0
    $(".view").html("<div class='minigame' style='width:100%; height:100%;'></div>")
    this.el = $(".minigame")
    this.el.append("<a href='#' class='btn'>Click me!</a>")
    this.el.append("<div class='score'>0</div>")
    this.el.find(".btn").bind 'click', =>
      this.score++
      this.render()
    setTimeout(this.end, 5000)

  render: =>
    $('.score').text(this.score)


  end: =>
    App.currentMetagame.clientGameover(this)

App.minigames.push new TapRace
