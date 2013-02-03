window.App =
  players: []
  Minigames: {}
  
socket = io.connect('/')

$("#user-form").submit ->
  socket.emit 'server: new player'
  socket.on "server: enter metagame", (data) ->
    if data.metagame_id?
      App.metagame = new App.Metagame(data.metagame_id)
      console.log "Connecting to #{data.metagame_id}"
      App.metagame.init(io, $(".username").val())
  $("button").attr('disabled', 'disabled')
  false



App.Utilities =
  checkOrientation: ->
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) and $(window).width() > $(window).height()
      alert('To play Mobile Party, you should use portrait orientation on your phone. (You may want to lock your phone in this orientation!)')
