import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Dashboard from '../views/Dashboard.vue'
import Analytics from '../views/Analytics.vue'
import Feedback from '../views/Feedback.vue'
import VStore from '../views/VStore.vue'
import RevenueSplit from '../views/RevenueSplit.vue'
import Documentation from '../views/Documentation.vue'
import Settings from '../views/Settings.vue'
import UserVerification from '../views/UserVerification.vue'
import Admin from '../views/Admin.vue'

import firebase from '../db/firebaseInit'

const routes = [
  {
    path: '/',
    component: Login,
    meta: {
      requiresGuest: true
    }
  },
  {
    path: '/dashboard',
    component: Dashboard,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/analytics',
    component: Analytics,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/feedback',
    component: Feedback,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/v-store',
    component: VStore,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/revenue-split',
    component: RevenueSplit,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/documentation',
    component: Documentation,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/settings',
    component: Settings,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/user-verification/:id',
    component: UserVerification,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/admin',
    component: Admin,
    meta: {
      requiresAuth: true
    }
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

const auth = firebase.auth()
const adminRef = firebase.firestore().collection('admin')

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!auth.currentUser) {
      next({
        path: '/'
      })
    } else {
      const id = auth.currentUser.uid
      adminRef.doc(id.toString().trim()).get().then((doc) => {
        if (doc.exists) {
          next()
        }
      })
    }
  } else if (to.matched.some(record => record.meta.requiresGuest)) {
    if (auth.currentUser) {
      const id = auth.currentUser.uid
      adminRef.doc(id.toString().trim()).get().then((doc) => {
        if (doc.exists) {
          next({
            path: '/dashboard'
          })
        }
      })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
