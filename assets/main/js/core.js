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
  e.preventDefault();
}

window.addEventListener('devicemotion', function (e) {
  // Stop the default behavior from triggering the shake-to-undo dialog (hopefully)
  e.preventDefault();
});

window.ondeviceorientation = function(event) {
  if (window.App && App.data){
    App.data.cX = Math.round(event.alpha);
    App.data.cY = Math.round(event.beta);
    App.data.cZ = Math.round(event.gamma);
  }
}

// Reset gyroscope
// document.ontouchstart = function(e){
//   if (window.App && App.data && App.data.cX){
//     App.adjustment.cX = App.data.cX;
//     App.adjustment.cY = App.data.cY;
//     App.adjustment.cZ = App.data.cZ;
//   }
// }