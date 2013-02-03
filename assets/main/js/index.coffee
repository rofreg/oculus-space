socket = io.connect('/')

form = $("#user-form")
form.onsubmit = ->
  socket.emit "new player", { name: this.elements["username"].value }
  socket.on "enter metagame", (data) =>
    if data.metagame_id?
      App.metagame = new App.Metagame(data.metagame_id)
      console.log "Connecting to #{data.metagame_id}"
      App.metagame.clientInit(io, this.elements["username"].value)
  $("button").attr('disabled', 'disabled')
  false
