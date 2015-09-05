var express = require("express");
var app = express();

var handleTextResponse = function(_req, res) {
  var time = new Date();
  res.set('Content-Type', 'text/plain');
  if (time.getMinutes() >= 30) {
    res.send("half past " + time.getHours());
  } else {
    res.send("" + time.getHours() + " O'clock");
  }
};

var handleJsonResponse = function(_req, res) {
  var time = new Date();
  var data = {
    stamp: Math.floor(time.getTime() / 1000),
    fullstamp: time.getTime() / 1000,
    string: time.toISOString(),
  };
  res.json(data);
};

app.get("/api/current-time.txt", handleTextResponse);
app.get("/api/current-time.json", handleJsonResponse);
app.get("/api/current-time", function(req, res) {
  var preferred = req.accepts(['text/plain', 'application/json']);
  if (preferred === 'application/json') {
    handleJsonResponse(req, res);
  } else {
    handleTextResponse(req, res);
  }
});

var port = parseInt(process.env.PORT || 3000, 10);
console.log("Starting Express server on port " + port);
app.listen(port);
