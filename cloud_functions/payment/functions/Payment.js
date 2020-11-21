require('dotenv').config()
const crypto = require('crypto')
const https = require("https")
const SITE_CODE = process.env.SITE_CODE
const PRIVATE_KEY = process.env.PRIVATE_KEY
const API_KEY = process.env.API_KEY
const VINK_TRIP_BANK_REFERENCE = process.env.VINK_TRIP_BANK_REFERENCE

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
  for (var k in data){
    if (data.hasOwnProperty(k)) {
      postData[k] = data[k]
    }
  }

  console.log(postData)
  return postData
}

var addToObject = function (obj, key, value, index) {

	// Create a temp object and index variable
	var temp = {};
	var i = 0;

	// Loop through the original object
	for (var prop in obj) {
		if (obj.hasOwnProperty(prop)) {

			// If the indexes match, add the new item
			if (i === index && key && value) {
				temp[key] = value;
			}

			// Add the current item in the loop to the temp obj
			temp[prop] = obj[prop];

			// Increase the count
			i++;

		}
	}

	// If no index, add to the end
	if (!index && key && value) {
		temp[key] = value;
	}

	return temp;

};

module.exports = {  
  paymentCheckout: (req, res) => {  

    return new Promise((resolve) => {

      let {
        TransactionReference, 
        Customer, 
        Optional1, 
        Optional2, 
        Optional3,
        Optional4,
        Optional5,
        Amount} 
      = req.body

      var postData = {
        "SiteCode": SITE_CODE,
        "CountryCode":"ZA",
        "CurrencyCode":"ZAR",
        "Amount":Amount,
        "TransactionReference":TransactionReference,
        "BankReference":VINK_TRIP_BANK_REFERENCE,
        "Optional1":Optional1,
        "Optional2":Optional2,
        "Optional3":Optional3,
        "Optional4":Optional4,
        "Optional5":Optional5,
        "Customer":Customer,
        "CancelUrl":"https://us-central1-vink8-za.cloudfunctions.net/payment/paymentCancelation",					
        "ErrorUrl":"https://us-central1-vink8-za.cloudfunctions.net/payment/paymentError",
        "SuccessUrl":"https://us-central1-vink8-za.cloudfunctions.net/payment/paymentSuccess",
        "IsTest":"false",
      }

      let stringToHash = makeHash(postData)
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