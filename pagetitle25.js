
var system = require('system');
var args = system.args;

var isDone=[];



if (args.length <= 1) {
    console.log('No website specified.');
    phantom.exit();
}

for (var k=1; k<args.length-1; k++) {
    isDone[k] = false;
}


function exitIfDone() {
  for (var j=1; j<args.length-1; j++) {
    if (isDone[j]==false) {
      return;
    }
  }
  phantom.exit();
}

function getOnePageTitle(url, index) {

  var page = require('webpage').create();
  console.log(url);
  page.onConsoleMessage = function(msg) {
    console.log(msg);
  };
  page.open(url, function(status) {
    page.evaluate(function() {
      console.log('Page title is ' + document.title);
    });

    isDone[index]=true;
    exitIfDone();
  });
}

for (var i=1; i<=args.length-1; i++) {
  url = args[i];
  getOnePageTitle(url, i);
}
