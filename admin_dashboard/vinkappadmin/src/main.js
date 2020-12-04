import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './assets/scss/app.scss'
import 'bootstrap'
import 'jquery'
import 'popper.js'
import Form from 'vform'
import Swal from 'sweetalert2'
import firebase from './db/firebaseInit'
window.Form = Form
const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 6000,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  }
})

window.showSuccess = function (msg) {
  Toast.fire({
    icon: 'success',
    title: msg
  })
}

window.showError = function (msg) {
  Toast.fire({
    icon: 'error',
    title: msg
  })
}

let app
firebase.auth().onAuthStateChanged(user => {
  if (!app) {
    app = createApp(App).use(store).use(router).mount('#app')
  }
})
