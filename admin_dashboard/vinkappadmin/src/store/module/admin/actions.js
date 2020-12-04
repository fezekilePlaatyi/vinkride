import firebase from '../../../db/firebaseInit'
import fb from 'firebase'
const db = firebase.firestore()
const adminRef = db.collection('admin')

export const addAdminToDb = ({ commit }, form) => {
  const password = generatePassword()
  form.password = password
  var authApp = fb.initializeApp({
    apiKey: 'AIzaSyBnfG7UQzHOar6LRFiMO1z470BPgTUAeDg',
    authDomain: 'vink8-za.firebaseapp.com',
    databaseURL: 'https://vink8-za.firebaseio.com',
    projectId: 'vink8-za',
    storageBucket: 'vink8-za.appspot.com',
    messagingSenderId: '539160998833',
    appId: '1:539160998833:web:8f0a8611c1ef140ab68390',
    measurementId: 'G-N82BWNPRQ2'
  }, 'authApp')
  var detachedAuth = authApp.auth()
  detachedAuth.createUserWithEmailAndPassword(form.email, form.password).then((data) => {
    var user = {
      name: form.name,
      email: form.email,
      created_at: new Date(),
      isBlocked: false
    }
    adminRef.doc(data.user.uid).set(user).then(() => {
      const sendEmail = firebase.functions().httpsCallable('sendEmail')
      form.message = `Your password for Vink admin app is <b>${password}<b>`
      sendEmail(form).then(() => {
        // eslint-disable-next-line no-undef
        showSuccess('Admin added succesfully')
        return true
      }).catch((error) => {
        // eslint-disable-next-line no-undef
        showError(error.message)
      })
    }).catch((error) => {
      // eslint-disable-next-line no-undef
      showError(error.message)
    })
  }).catch((error) => {
    // eslint-disable-next-line no-undef
    showError(error.message)
  })
}

export const getAdmins = ({ commit }) => {
  adminRef.onSnapshot((doc) => {
    commit('GET_ADMINS', doc.docs)
  })
}

export const getCurrentAdmin = ({ commit }) => {
  const auth = firebase.auth()
  adminRef.doc(auth.currentUser.uid).onSnapshot((doc) => {
    commit('GET_CURRENT_ADMIN', doc)
  })
}

export const blockAdmin = ({ commit }, user) => {
  adminRef.doc(user.id).update({ isBlocked: !user.data().isBlocked })
}

function generatePassword () {
  var length = 8
  var charset = '0123456789'
  var retVal = ''
  for (var i = 0, n = charset.length; i < length; ++i) {
    retVal += charset.charAt(Math.floor(Math.random() * n))
  }
  return retVal
}
