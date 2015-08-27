(function() {
  var k, lazy, v;

  lazy = require('./lazy');

  for (k in lazy) {
    v = lazy[k];
    global[k] = v;
  }

}).call(this);
