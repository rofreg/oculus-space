App =
  room: null,
  data: {}
  
socket = io.connect('/')

socket.on "disconnect", (data) ->
  $('#disconnected').fadeIn(500)
  setTimeout("location.href = '/'", 4500)

socket.on 'connect', () ->
  # immediately go create a room
  socket.emit 'init: add client'
  console.log("Establishing room...")

socket.on "init: connected to room", (data) ->
  console.log("Connected to room: "+data.room)
  App.room = data.room

