"use strict";

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance"); }

function _iterableToArrayLimit(arr, i) { if (!(Symbol.iterator in Object(arr) || Object.prototype.toString.call(arr) === "[object Arguments]")) { return; } var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

require('dotenv').config();

var crypto = require('crypto');

var https = require("https");

var SITE_CODE = process.env.SITE_CODE;
var PRIVATE_KEY = process.env.PRIVATE_KEY;
var API_KEY = process.env.API_KEY;

var makeHash = function makeHash(data) {
  var stringToHash = "";

  for (var _i = 0, _Object$entries = Object.entries(data); _i < _Object$entries.length; _i++) {
    var _Object$entries$_i = _slicedToArray(_Object$entries[_i], 2),
        key = _Object$entries$_i[0],
        value = _Object$entries$_i[1];

    var row = value;
    stringToHash += row;
  }

  stringToHash = stringToHash + PRIVATE_KEY;
  var hash = crypto.createHash('sha512').update(stringToHash.toLowerCase()).digest('hex');
  return hash;
};

var appendPaymentPostData = function appendPaymentPostData(data, postData) {
  for (var _i2 = 0, _Object$entries2 = Object.entries(data); _i2 < _Object$entries2.length; _i2++) {
    var _Object$entries2$_i = _slicedToArray(_Object$entries2[_i2], 2),
        key = _Object$entries2$_i[0],
        value = _Object$entries2$_i[1];

    var appendKey = key;
    postData[appendKey] = value;
  }

  console.log("START");
  console.log(data);

  for (var k in data) {
    if (target.hasOwnProperty(k)) {
      postData[k] = data[k];
    }
  }

  console.log("FINAL");
  console.log(postData);
  return postData;
};

module.exports = {
  paymentCheckout: function paymentCheckout(res, req) {
    return new Promise(function (resolve) {
      /*
      var obj = {key1: "value1", key2: "value2"};
      Object.assign(obj, {key3: "value3"});
      console.log(res.body)
      "TransactionReference": "Vink Trip Payment",
                "BankReference": "Vink Trip Payment",
                "Customer": "Test Customer",
                "Optional1": auth.currentUser.uid,
                "Amount": messageData['amount'],
                "Optional2": messageData['trip_id'],
          */
      //  "TransactionReference": "Vink Trip Payment",
      //  "BankReference": "Vink Trip Payment",
      //  "Customer": "Test Customer",
      //  "Optional1": auth.currentUser.uid,
      //  "Amount": messageData['amount'],
      //  "Optional2": messageData['trip_id'],
      var postData = {
        "SiteCode": SITE_CODE,
        "CountryCode": "ZA",
        "CurrencyCode": "ZAR",
        "CancelUrl": "https://us-central1-vink8-za.cloudfunctions.net/payment/paymentCancelation",
        "ErrorUrl": "https://us-central1-vink8-za.cloudfunctions.net/payment/paymentError",
        "SuccessUrl": "https://us-central1-vink8-za.cloudfunctions.net/payment/paymentSuccess",
        "IsTest": "false"
      };
      var updatedPostData = appendPaymentPostData(res.body, postData);
      var stringToHash = makeHash(updatedPostData);
      postData['HashCheck'] = stringToHash;
      var urlPath = '/PostPaymentRequest';
      var url = 'api.ozow.com';
      var options = {
        host: url,
        path: urlPath,
        method: 'POST',
        headers: {
          'ApiKey': API_KEY,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      };
      var postRequest = https.request(options, function (res) {
        res.setEncoding("utf8");
        res.on("data", function (chunk) {
          jsonRes = JSON.parse(chunk);
          resolve(jsonRes);
        });
      });
      postRequest.write(JSON.stringify(postData));
      postRequest.end();
    });
  }
};