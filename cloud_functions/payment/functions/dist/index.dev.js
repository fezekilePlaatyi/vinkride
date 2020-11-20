"use strict";

var functions = require('firebase-functions');

var express = require('express');

var app = express();

var bodyParser = require("body-parser");

app.set("view engine", "ejs");
app.set("views", __dirname + "/views");
app.use(bodyParser.urlencoded({
  extended: false
}));
app.use(express["static"](__dirname + '/public'));

var Payment = require("./Payment");

var PORT = 7000;
app.post('/paymentCheckout', function (req, res) {
  paymentCheckout(req, res);
});
app.get('/paymentNotifications', function (req, res) {
  console.log("Payment notification ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.get('/paymentSuccess', function (req, res) {
  console.log("Payment Success ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.get('/paymentCancelation', function (req, res) {
  console.log("Payment Cancelation ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.get('/paymentError', function (req, res) {
  console.log("Payment Error ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.post('/paymentNotifications', function (req, res) {
  console.log("Payment notification ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.post('/paymentSuccess', function (req, res) {
  console.log("Payment Success ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.post('/paymentCancelation', function (req, res) {
  console.log("Payment Cancelation ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.post('/paymentError', function (req, res) {
  console.log("Payment Error ".concat(req, " ").concat(res));
  res.send({
    "Results": req
  });
});
app.listen(PORT, function () {
  console.log("Server started at port - ".concat(PORT));
});

var paymentCheckout = function paymentCheckout(req, res) {
  var result;
  return regeneratorRuntime.async(function paymentCheckout$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.next = 2;
          return regeneratorRuntime.awrap(Payment.paymentCheckout(req, res));

        case 2:
          result = _context.sent;
          result.errorMessage == null ? res.send({
            "url": jsonRes.url
          }) : res.send({
            "error": jsonRes
          });

        case 4:
        case "end":
          return _context.stop();
      }
    }
  });
};

exports.app = functions.https.onRequest(app);