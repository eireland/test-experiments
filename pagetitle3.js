var system = require('system');

var args = system.args;
var done = [];

if (system.args.length <= 1) {

  console.log('No website specified');

  phantom.exit();
}

for (var i = 0; i < args.length - 1; i++) {
  done[i] = false;
}

function exitIfDone() {
    for (var k = 0; k < args.length - 1; k++) {
        if (done[k] == false) {
            return;
        }
    }
    phantom.exit();
}

function retrieveOneTitle(url, index) {
    var page = require('webpage').create();

    page.onConsoleMessage = function(msg) {
      console.log('Page title is ' + msg);
    };

    page.open(url, function(status) {
        page.evaluate(function() {
          console.log(document.title);
        });
        done[index] = true;
        exitIfDone();
    });

}

for (var j = 0; j < args.length - 1; j++) {
  retrieveOneTitle(args[j + 1], j);
}
