// Avoid `console` errors in browsers that lack a console.
(function() {
  var method;
  var noop = function () {};
  var methods = [
    'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
    'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
    'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
    'timeStamp', 'trace', 'warn'
  ];
  var length = methods.length;
  var console = (window.console = window.console || {});

  while (length--) {
    method = methods[length];

    // Only stub undefined methods.
    if (!console[method]) {
      console[method] = noop;
    }
  }
}());

// Prevent scrolling on mobile
document.ontouchmove = function(e){
  // e.preventDefault();
  viewport = document.querySelector("meta[name=viewport]")
}

window.onresize = function(e){
  try {
    App.Utilities.checkOrientation();
  } catch (e) {
    // App not loaded yet
  }
}

window.onload = function(e){
  try {
    App.Utilities.checkOrientation();
  } catch (e) {
    // App not loaded yet
  }
}