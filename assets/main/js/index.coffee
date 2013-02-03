window.App =
  players: []
  Minigames: {}
  Templates: {}
  
socket = io.connect('/')
socket.on "player: your id", (data) ->
  App.player_id = data.id
socket.on "disconnect", (data) ->
  console.log('test');
  $('#disconnected').fadeIn(500)
  $('#overlay').fadeIn(500).css('z-index', 9999)
  setTimeout("location.href = '/'", 6000)

$("#user-form").submit ->
  $("button").attr('disabled', 'disabled')
  socket.emit 'server: new player'
  socket.on "server: enter metagame", (data) ->
    if data.metagame_id?
      App.metagame = new App.Metagame(data.metagame_id)
      console.log "Connecting to #{data.metagame_id}"
      App.metagame.init(io, $(".username").val())
  false



App.Utilities =
  warningGiven: false
  checkOrientation: ->
    if !App.Utilities.warningGiven and /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) and $(window).width() > $(window).height()
      alert('To play Mobile Party, you should use portrait orientation on your phone. (You may want to lock your phone in this orientation!)')
      App.Utilities.warningGiven = true