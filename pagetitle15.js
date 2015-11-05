var page = require('webpage').create(),
  system = require('system'),
  url;


if (system.args.length <= 1) {

  console.log('No website specified');

  phantom.exit();
}
else {

  url = system.args[1];

  page.onConsoleMessage = function(msg) {
    console.log(url + 'Page title is ' + msg);
  };

  page.open(url, function(status) {
    page.evaluate(function() {
      console.log(document.title);
    });
    phantom.exit();
  });
}
