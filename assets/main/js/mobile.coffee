App =
  room: null,
  data: {}
  
socket = io.connect('/')

socket.on "disconnect", (data) ->
  $('#disconnected').fadeIn(500)
  setTimeout("location.href = location.href", 4500)

socket.on "init: connected to room", (data) ->
  console.log("Connected to room: "+data.room)
  App.room = data.room

$("#initialize").submit ->
  $("#initialize button").attr('disabled', 'disabled').text("Connecting...")
  $("#initialize input").blur()
  socket.emit 'init: add controller', room: $("#initialize input").val()
  false