const functions = require('firebase-functions')
var express = require('express')
var app = express()
const bodyParser = require("body-parser")
app.set("view engine", "ejs")
app.set("views", __dirname + "/views")
app.use(bodyParser.urlencoded({ extended: false }))
app.use(express.static(__dirname + '/public'))
var Payment = require("./Payment")

const PORT = 7000

app.post('/paymentCheckout', (req, res) => {
    paymentCheckout(req, res)
})

app.get('/paymentNotifications', (req, res) => {
    console.log(`Payment notification ${req} ${res}`)
    res.send({"Results": req})
})

app.get('/paymentSuccess', (req, res) => {
    console.log(`Payment Success ${req} ${res}`)
    res.send({"Results": req})
})

app.get('/paymentCancelation', (req, res) => {
    console.log(`Payment Cancelation ${req} ${res}`)
    res.send({"Results": req})
})

app.get('/paymentError', (req, res) => {
    console.log(`Payment Error ${req} ${res}`)
    res.send({"Results": req})
})

app.post('/paymentNotifications', (req, res) => {
    console.log(`Payment notification ${req} ${res}`)
    res.send({"Results": req})
})

app.post('/paymentSuccess', (req, res) => {
    console.log(`Payment Success ${req} ${res}`)
    res.send({"Results": req})
})

app.post('/paymentCancelation', (req, res) => {
    console.log(`Payment Cancelation ${req} ${res}`)
    res.send({"Results": req})
})

app.post('/paymentError', (req, res) => {
    console.log(`Payment Error ${req} ${res}`)
    res.send({"Results": req})
})

app.listen(PORT, () => {
    console.log(`Server started at port - ${PORT}`)
})

const paymentCheckout = async (req, res) => {
    const result = await Payment.paymentCheckout(req, res)
    result.errorMessage == null ?
        res.send({"url": jsonRes.url})
        :
        res.send({"error": jsonRes})
}

exports.app = functions.https.onRequest(app)