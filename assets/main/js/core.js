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
document.ontouchstart = function(e){
  e.preventDefault();
}

// On window resize/rotation, recalculate screen dimensions
window.onresize = function(e){
  App.Utilities.resizeViewport();
}

window.onload = function(e){
  App.Utilities.resizeViewport();
}

App = {}
App.Utilities = {}
App.Utilities.resizeViewport = function(){
  var windowSize = {
    width: $(window).width(),
    height: $(window).height()
  }

  // Find the currently active view and determine its dimensions
  var view = $('body > div.view.active');
  if (view.length == 0)
    return;

  var viewSize = {
    width: view.width(),
    height: view.height()
  }

  // Place all views in the middle of the screen
  view.css({
    position: 'absolute',
    top: '50%',
    left: '50%',
    marginTop: "-"+(viewSize.height / 2)+"px",
    marginLeft: "-"+(viewSize.width / 2)+"px"
  })

  // If item is wider than it is tall, ratio > 1
  windowSize.ratio = windowSize.width * 1.0 / windowSize.height;
  viewSize.ratio = viewSize.width * 1.0 / viewSize.height;
  viewport = document.querySelector("meta[name=viewport]");

  // Resize the mobile window to fit the active view (with letterboxing)
  if (viewSize.ratio < windowSize.ratio){
    // The view is taller/narrower than the window.
    // We'll need letterboxing on the left and right.
    viewport.setAttribute('content',
      'width='+(viewSize.height * windowSize.ratio)+', user-scalable=0');
  } else {
    // The view is shorter and fatter than the window.
    // We'll need letterboxing on top and bottom.
    viewport.setAttribute('content','width='+viewSize.width+', user-scalable=0');
  }
}