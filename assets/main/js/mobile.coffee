window.App =
  room: null,
  data: {},
  adjustment: {cX:0, cY:0, cZ:0},
  utils: {}
  DEBUG_MODE: true
  
socket = io.connect('/')

socket.on 'connect', (data) ->
  if App.DEBUG_MODE
    # for testing: immediately connect to the first available room
    socket.emit 'init: add controller'
  if App.refreshTimeout
    clearInterval(App.refreshTimeout)
    $('#disconnected').fadeOut(500)

socket.on "disconnect", (data) ->
  $('#disconnected').fadeIn(500)
  App.refreshTimeout = setTimeout("location.href = location.href", 4500)

socket.on "server: client disconnected", (data) ->
  $('#disconnected').fadeIn(500)
  setTimeout("location.href = location.href", 4500)

socket.on "init: connected to room", (data) ->
  App.room = data.room
  $('#room_id').text(data.room)
  $('#mobile_hud').fadeIn(300)
  setInterval ->
    socket.emit 'broadcast', {room: App.room, event: "room: data", data: {
      cX: App.utils.normalize(App.data.cX - App.adjustment.cX),
      cY: App.utils.normalize(App.data.cY - App.adjustment.cY),
      cZ: App.utils.normalize(App.data.cZ - App.adjustment.cZ)
    }}
  , 100
  # TODO: make sure a data broadcast is received before sending the next one
  # (i.e. don't flood the client if there's lag)

$("#initialize").submit ->
  $("#initialize button").attr('disabled', 'disabled').text("Connecting...")
  $("#initialize input").blur()
  socket.emit 'init: add controller', room: $("#initialize input").val()
  false

$('#room').keyup ->
  $('#room').val($('#room').val().toUpperCase())

App.utils.normalize = (number, range = 360) ->
  if not typeof number == "number"
    0
  else
    number -= range while number > range / 2
    number += range while number < -range / 2
    number
