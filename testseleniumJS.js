 /* Created by evangelineireland on 1/5/15.*/
var webdriver = require("selenium-webdriver");

function createDriver() {
  var browser = new webdriver.Builder()
    .usingServer('http://localhost:4444/wd/hub')
    .withCapabilities({'browserName':'firefox'})
    .build();

  browser.manage().timeouts().setScriptTimeout(10000);
  return browser;
}

var browser = createDriver();

 browser.get('http://codap.concord.org/releases/latest/static/dg/en/cert/index.html?moreGames=%5B%7B%22name%22:%22Performance%20Harness%22,%22dimensions%22:%7B%229width%22:400,%22height%22:250%7D,%22url%22:%22http://concord-consortium.github.io/codap-data-interactives//PerformanceHarness/PerformanceHarness.html%22%7D%5D');

 var tableButton = browser.findElement(webdriver.By.xpath('//div/canvas[@alt="Table"]'));
 tableButton.click();

 var iframeLoc = browser.findElements(webdriver.By.tagName("iframe"));
 browser.switchTo().frame(iframeLoc);

 var trials = browser.findElement(webdriver.By.name("numTrials"));
 trials.clear();
 trials.sendKeys('200');

 var runButton =  browser.findElement(webdriver.By.name("run"));
 runButton.click();

 //browser.getTitle().then(function(title) {
 //  require('assert').equal('webdriver - Google Search', title);

// });
//browser.quit();

/* browser.get("http://codap.concord.org/releases/build_0278/static/dg/en/cert/index.html?moreGames=%5B%7B%22name%22:%22Performance%20Harness%22,%22dimensions%22:%7B%229width%22:400,%22height%22:250%7D,%22url%22:%22http://concord-consortium.github.io/codap-data-interactives//PerformanceHarness/PerformanceHarness.html%22%7D%5D");

browser.getTitle().then(function (title) {
  console.log(title);
});

var trials = browser.findElements(webdriver.By.name('numTrials'));
trials.then(function(trials){
  trials.clear;
  trials.sendKeys('200');

var runButton = browser.findElement(webdriver.By.name('run'));
runButton.click();*/

/*var tableButton = driver.findElement(webdriver.By.xpath("//div[@title='Open/close the case table (ctrl-alt-t)']"))
  .then(function(tableBtn){
    console.log(tableBtn);
  })

    tableButton.click();*/




/*
var frame = browser.findElements(webdriver.By.css("iframe"));
frame.then(function(frame){
  driver.switch_to.frame(frame);
});

var trials = browser.findElements(webdriver.By.name('numTrials'));
trials.then(function(trials){
  trials.clear;
  trials.sendKeys('200');
})
*/



//browser.findElements(By.XPath("//div[label='Login as guest']"));

//
