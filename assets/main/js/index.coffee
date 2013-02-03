socket = io.connect('/')

<<<<<<< HEAD
form = $("#user-form")
form.submit = ->
  player = new App.Player $("input[name='username']").val
  App.players.push player
  socket.emit "new player", { name: App.player }
  socket.on "enter metagame", (data) ->
=======
form = document.getElementById("user-form")
form.onsubmit = ->
  socket.emit "new player", { name: this.elements["username"].value }
  socket.on "enter metagame", (data) =>
>>>>>>> f4df554a2fdfbd0a234e20ad829371dae4725634
    if data.metagame_id?
      App.metagame = new App.Metagame(data.metagame_id)
      console.log "Connecting to #{data.metagame_id}"
      App.metagame.clientInit(io, this.elements["username"].value)
  $("button").attr('disabled', 'disabled')
  false
