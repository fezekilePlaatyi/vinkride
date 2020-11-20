require('dotenv').config()
const crypto = require('crypto')
const https = require("https")
const SITE_CODE = process.env.SITE_CODE
const PRIVATE_KEY = process.env.PRIVATE_KEY
const API_KEY = process.env.API_KEY

const makeHash = (data) => {
  let stringToHash = ""
  for (const [key, value] of Object.entries(data)) {
      let row = value
      stringToHash += row
  }
  stringToHash =  stringToHash+PRIVATE_KEY
  var hash = crypto.createHash('sha512').update(stringToHash.toLowerCase()).digest('hex');
  return hash
}

const appendPaymentPostData = (data, postData) => {
  for (const [key, value] of Object.entries(data)) {
    let appendKey = key    
    postData[appendKey] = value
  }

  
  console.log("START")
  console.log(data)

  for (var k in data){
    if (target.hasOwnProperty(k)) {
      postData[k] = data[k]
    }
  }

  console.log("FINAL")
  console.log(postData)
  return postData
}

module.exports = {  
  paymentCheckout: (res, req) => {
    return new Promise((resolve) => {
    
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
          "CountryCode":"ZA",
          "CurrencyCode":"ZAR",
          "CancelUrl":"https://us-central1-vink8-za.cloudfunctions.net/payment/paymentCancelation",					
          "ErrorUrl":"https://us-central1-vink8-za.cloudfunctions.net/payment/paymentError",
          "SuccessUrl":"https://us-central1-vink8-za.cloudfunctions.net/payment/paymentSuccess",
          "IsTest":"false",
      }

      var updatedPostData = appendPaymentPostData(res.body, postData)
      
      let stringToHash = makeHash(updatedPostData)
      postData['HashCheck'] = stringToHash

      var urlPath ='/PostPaymentRequest'
      var url = 'api.ozow.com'

      var options = {
          host: url,
          path: urlPath,
          method: 'POST',
          headers: {
              'ApiKey': API_KEY,
              'Content-Type': 'application/json',
              'Accept': 'application/json'
          },
      }

      var postRequest = https.request(options, function (res) {
        res.setEncoding("utf8")
        res.on("data", function (chunk) {
          jsonRes = JSON.parse(chunk)
          resolve(jsonRes)
        })
      })
      postRequest.write(JSON.stringify(postData))
      postRequest.end()
    }) 
  }
}