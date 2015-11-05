/**
 * Created by evangelineireland on 10/27/14.
 */

var loginButton='html=sc-button-label:contains("Login as guest")'
var page = require('webpage').create(),
    url = 'http://localhost:4020/dg?moreGames=[{%22name%22:%22PerformanceHarness%22,%22dimensions%22:{%22width%22:550,%22height%22:500},%22url%22:%22http://concord-consortium.github.io/codap-data-interactives/PerformanceHarness/PerformanceHarness.html%22}]';

//console.log('The default user agent is '+page.settings.userAgent);
page.settings.userAgent = 'SpecialAgent';

page.onConsoleMessage = function(msg) {
  console.log("Login button ID is: " + msg);
};


page.open(url, function (status){

//  console.log(status, url);
  if (status !== 'success'){
    console.log('Unable to open page');
    phantom.exit();
  } else {
/*    var selection = page.evaluate(function () {
      return document.getElementById('loginButton');
      console.log(selection);*/
      page.evaluate(function(){
      console.log(this.getPath('loginButton'))
    });

    phantom.exit();
  }
})

