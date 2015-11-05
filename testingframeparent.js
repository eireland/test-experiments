/**
 * Created by evangelineireland on 1/12/15.
 */
var webdriver = require("selenium-webdriver");

function createDriver() {
  var browser = new webdriver.Builder()
    .usingServer('http://localhost:4444/wd/hub')
    .withCapabilities({'browserName':'chrome'})
    .build();

  browser.manage().timeouts().setScriptTimeout(10000);
  return browser;
}

var browser = createDriver();

browser.get('file:///Users/evangelineireland/Sites/CODAP-experiments/testframeparent.html');


var iframeTag = browser.findElement(webdriver.By.tagName("iframe"));
browser.switchTo().frame(iframeTag);

var trials = browser.findElement(webdriver.By.name("numTrials"));
trials.clear();
trials.sendKeys('200');

var runButton =  browser.findElement(webdriver.By.name('run'));
runButton.click();


/*browser.findElement(webdriver.By.id("iframe1"));
browser.switchTo().frame("iframe1");

var trials = browser.findElement(webdriver.By.id("numTrialsId"));
trials.clear();
trials.sendKeys('200');

var runButton =  browser.findElement(webdriver.By.id('runButton'));
runButton.click();*/

//browser.getTitle().then(function(title) {
//  require('assert').equal('webdriver - Google Search', title);

// });
//browser.quit();