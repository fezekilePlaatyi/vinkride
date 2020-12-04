import { createStore } from 'vuex'
import state from './state'
import * as mutations from './mutations'
import * as actions from './actions'
import admin from './module/admin'

export default createStore({
  state,
  mutations,
  actions,
  modules: {
    admin
  }
})
