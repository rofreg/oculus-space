// Generated by CoffeeScript 1.6.3
(function() {
  var socket;

  window.App = {
    room: null,
    data: {},
    adjustment: {
      cX: 0,
      cY: 0,
      cZ: 0
    },
    utils: {},
    DEBUG_MODE: false
  };

  socket = io.connect('/');

  socket.on('connect', function(data) {
    if (App.DEBUG_MODE) {
      socket.emit('init: add controller');
    }
    if (App.refreshTimeout) {
      clearInterval(App.refreshTimeout);
      return $('#disconnected').fadeOut(500);
    }
  });

  socket.on("disconnect", function(data) {
    $('#disconnected').fadeIn(500);
    return App.refreshTimeout = setTimeout("location.href = location.href", 4500);
  });

  socket.on("server: client disconnected", function(data) {
    $('#disconnected').fadeIn(500);
    return setTimeout("location.href = location.href", 4500);
  });

  socket.on("init: connected to room", function(data) {
    App.room = data.room;
    $('#room_id').text(data.room);
    $('#mobile_hud').fadeIn(300);
    return setInterval(function() {
      return socket.emit('broadcast', {
        room: App.room,
        event: "room: data",
        data: {
          cX: App.utils.normalize(App.data.cX - App.adjustment.cX),
          cY: App.utils.normalize(App.data.cY - App.adjustment.cY),
          cZ: App.utils.normalize(App.data.cZ - App.adjustment.cZ)
        }
      });
    }, 100);
  });

  $("#initialize").submit(function() {
    $("#initialize button").attr('disabled', 'disabled').text("Connecting...");
    $("#initialize input").blur();
    socket.emit('init: add controller', {
      room: $("#initialize input").val()
    });
    return false;
  });

  $('#room').keyup(function() {
    return $('#room').val($('#room').val().toUpperCase());
  });

  App.utils.normalize = function(number, range) {
    if (range == null) {
      range = 360;
    }
    if (!typeof number === "number") {
      return 0;
    } else {
      while (number > range / 2) {
        number -= range;
      }
      while (number < -range / 2) {
        number += range;
      }
      return number;
    }
  };

  document.ontouchstart = function() {
    if (App.room) {
      socket.emit('broadcast', {
        room: App.room,
        event: "fire",
        data: {}
      });
      return window.App.boostTimeout = setTimeout(function() {
        socket.emit('broadcast', {
          room: App.room,
          event: "boost",
          data: {
            on: true
          }
        });
        return window.App.boostTimeout = void 0;
      }, 500);
    }
  };

  document.ontouchend = function() {
    if (App.room) {
      if (window.App.boostTimeout) {
        return clearTimeout(App.boostTimeout);
      } else {
        return socket.emit('broadcast', {
          room: App.room,
          event: "boost",
          data: {
            on: false
          }
        });
      }
    }
  };

}).call(this);
