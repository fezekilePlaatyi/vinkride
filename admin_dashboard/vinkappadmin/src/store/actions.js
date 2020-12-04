/* eslint-disable no-undef */
import firebase from '../db/firebaseInit'

import router from '../router'

const db = firebase.firestore()
const auth = firebase.auth()
const categoryRef = db.collection('vink_category')
const userRef = db.collection('users')
const adminRef = db.collection('admin')
const requestRef = db.collection('requests')

/**
 * =================== | AUTH FUNCTIONS | ==================================
 */
export const login = ({ commit }, payload) => {
  console.log(payload.email)
  auth.signInWithEmailAndPassword(payload.email.toString().trim(), payload.password.toString().trim()).then(() => {
    var id = firebase.auth().currentUser.uid
    adminRef.doc(id).get().then((doc) => {
      if (doc.exists) {
        router.push('/dashboard')
      } else {
        showError('Not authorised')
        auth.signOut()
      }
    })
  }).catch((error) => {
    showError(error.message)
    console.error(error.message)
  })
}

export const logOut = () => {
  auth.signOut().then(() => {
    router.push('/')
  })
}

/**
 * =================== | ADD FUNCTIONS | ==================================
 */
export const addCategory = (payload) => {
  categoryRef.add(payload).then(() => {
    console.log('Success')
  }).catch((error) => {
    console.error(error)
  })
}

export const addSkill = (payload) => {
  db.collection('vink_categories').doc(payload.category_id)
    .collection('category_skills').doc(payload.skill_name)
    .add({ price: payload.price }).then((data) => {
      console.log(data)
    }).catch((error) => {
      console.error(error)
    })
}

/**
 * =================== | GET FUNCTIONS | ==================================
 */
// Get functions
export const getCategories = () => {
  categoryRef.onSnapshot((doc) => {
    commit('GET_CATEGORIES', doc.docs)
  })
}

export const getSkills = ({ commit }, payload) => {
  db.collection('vink_category').doc(payload).collection('category_skills').onSnapshot((doc) => {
    commit('GET_SKILLS', doc.docs)
  })
}

export const getUnverifiedUsers = ({ commit }) => {
  userRef.orderBy('created_at')
    .where('isExpert', '==', true).where('isVerified', '==', false).onSnapshot((doc) => {
      commit('GET_UNVERIFIED_USERS', doc.docs)
    })
}

export const getUser = ({ commit }, id) => {
  userRef.doc(id).onSnapshot((doc) => {
    console.log(doc.data())
    commit('GET_USER', doc.data())
  })
}

export const getRequests = () => {
  requestRef.where('request_status', '==', 'COMPLETED').onSnapshot((doc) => {
    commit('GET_REQUESTS', doc.docs)
  })
}

export const getAdmins = () => {
  adminRef.orderBy('created_at', '==', desc).onSnapshot((doc) => {
    commit('GET_ADMINS', doc.docs)
  })
}

export const verifyUser = ({ commit }, form) => {
  const sendEmail = firebase.functions().httpsCallable('sendEmail')
  if (form.isApproved) {
    userRef.doc(form.id.toString().trim()).update({ isVerified: true }).then(() => {
      sendEmail(form).then(() => {
        showSuccess('User is now approved')
      }).catch((error) => {
        console.error(error.message)
      })
    })
  } else {
    sendEmail(form).then(() => {
      showSuccess('Email Sent')
      return true
    }).catch((error) => {
      console.error(error.message)
    })
  }
}
