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
  for (var k in data) {
    if (data.hasOwnProperty(k)) {
      postData[k] = data[k];
    }
  }

  console.log(postData);
  return postData;
};

var addToObject = function addToObject(obj, key, value, index) {
  // Create a temp object and index variable
  var temp = {};
  var i = 0; // Loop through the original object

  for (var prop in obj) {
    if (obj.hasOwnProperty(prop)) {
      // If the indexes match, add the new item
      if (i === index && key && value) {
        temp[key] = value;
      } // Add the current item in the loop to the temp obj


      temp[prop] = obj[prop]; // Increase the count

      i++;
    }
  } // If no index, add to the end


  if (!index && key && value) {
    temp[key] = value;
  }

  return temp;
};

module.exports = {
  paymentCheckout: function paymentCheckout(req, res) {
    return new Promise(function (resolve) {
      var _req$body = req.body,
          TransactionReference = _req$body.TransactionReference,
          BankReference = _req$body.BankReference,
          Customer = _req$body.Customer,
          Optional1 = _req$body.Optional1,
          Optional2 = _req$body.Optional2,
          Amount = _req$body.Amount;
      var postData = {
        "SiteCode": SITE_CODE,
        "CountryCode": "ZA",
        "CurrencyCode": "ZAR",
        "Amount": Amount,
        "TransactionReference": TransactionReference,
        "BankReference": BankReference,
        "Customer": "Test Customer",
        "CancelUrl": "https://us-central1-vink8-za.cloudfunctions.net/payment/paymentCancelation",
        "ErrorUrl": "https://us-central1-vink8-za.cloudfunctions.net/payment/paymentError",
        "SuccessUrl": "https://us-central1-vink8-za.cloudfunctions.net/payment/paymentSuccess",
        "IsTest": "false"
      };
      var stringToHash = makeHash(postData);
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