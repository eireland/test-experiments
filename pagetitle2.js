
var system = require('system');
var args = system.args;
var url;

console.log('Before args length check');

if (args.length <= 1) {
    console.log('No website specified.');
}
else {

     for (var i=1; i < args.length; i++) {

          url = args[i];

          console.log(url);

          var page = require('webpage').create();

          console.log(url);

          page.onConsoleMessage = function(msg) {
                console.log(msg);
          };
          
          page.open(url, function(status) {
                page.evaluate(function() {

                    console.log("hello");
                    console.log(document.title);
                    //title[i]=document.title;
                    //console.log(document.location + 'Page title is ' + title[i]);
                    });

                });

          }
}
phantom.exit();
