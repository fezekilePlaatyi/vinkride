<template>
  <div>
    <nav-bar />
    <div class="container">
      <div class="card border-0 rounded-0 shadow-lg">
        <div class="card-header border-0 bg-white shadow-sm">
          <div class="d-flex">
            <div>Admins</div>
            <div class="d-flex ml-auto">
              <div class="d-flex mr-5" v-if="addAdmin">
                <input type="text" v-model="form.name" class="mx-5 border-0" placeholder="Name">
                <input type="text" v-model="form.email" class="mx-5 border-0" placeholder="Email">
              </div>
              <button class="btn btn-vink text-white outline-none border-0 mr-3" v-if="addAdmin" @click.prevent="cancelAddAdmin()">Close</button>
              <button class="btn btn-vink text-white outline-none border-0" @click.prevent="toggleAddAdmin()">{{addAdmin? 'Save Admin':'add Admin'}}</button>
            </div>
          </div>
        </div>
        <div class="card-body">
          <div v-if="admins.length > 0">
            <div class="row">
              <div class="col-3" v-for="admin in admins" :key="admin.id">
                <div class="card  border-0 bg-custom text-white">
                  <div class="card-body text-center">
                    {{admin.data().name}}
                  </div>
                  <div class="card-footer border-0 rounded-0 d-flex justify-content-between">
                    <i :class="'isBlocked' in admin.data() ? admin.data().isBlocked ? 'text-success' : 'text-danger'  : ''" class="fas fa-minus-circle fa-2x" @click.prevent="blockUser(admin)"></i>
                    <i class="fas fa-user-minus fa-2x"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <h3 v-else>No one here</h3>
        </div>
      </div>

    </div>
  </div>
</template>
<script>
import NavBar from '@/components/NavBar'
import { mapActions, mapState } from 'vuex'
export default {
  data () {
    return {
      addAdmin: false,
      error: '',
      // eslint-disable-next-line no-undef
      form: new Form({
        name: '',
        email: '',
        password: '',
        subject: 'Account creation for vink admin',
        message: ''
      })
    }
  },
  components: {
    NavBar
  },
  computed: {
    ...mapState('admin', ['admins', 'admin'])
  },
  methods: {
    ...mapActions('admin', ['getAdmins', 'addAdminToDb', 'getCurrentAdmin', 'blockAdmin']),
    toggleAddAdmin () {
      if (this.addAdmin) {
        if (!this.validateForm()) {
          // eslint-disable-next-line no-undef
          showError(this.error)
          // eslint-disable-next-line no-useless-return
          return
        }
        this.addAdminToDb(this.form).then((data) => {
          console.log(data)
        })
      } else {
        this.addAdmin = !this.addAdmin
      }
    },
    cancelAddAdmin () {
      this.form.reset()
      this.addAdmin = !this.addAdmin
    },
    validateForm () {
      var form = this.form
      if (form.name === '') {
        this.error = 'Please provide a name for this person'
        return false
      }

      if (form.email === '') {
        this.error = 'Please provide an email for this person'
        return false
      }

      return true
    },
    blockUser (admin) {
      this.blockAdmin(admin)
    }
  },
  mounted () {
    this.getCurrentAdmin()
    this.getAdmins()
  }
}
</script>
<style  scoped>
.container {
  margin-left: 16.5%;
  margin-top: 4.5%;
}
.btn-vink {
  background: #16222a; /* fallback for old browsers */
  background: -webkit-linear-gradient(
    to right,
    #3a6073,
    #16222a
  ); /* Chrome 10-25, Safari 5.1-6 */
  background: linear-gradient(
    to right,
    #3a6073,
    #16222a
  ); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
}

.modal-dialog {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

.modal-content {
  height: auto;
  min-height: 100%;
  border-radius: 0;
}

.bg-custom {
  background: #16222a; /* fallback for old browsers */
  background: -webkit-linear-gradient(
    to right,
    #3a6073,
    #16222a
  ); /* Chrome 10-25, Safari 5.1-6 */
  background: linear-gradient(
    to right,
    #3a6073,
    #16222a
  ); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
}

input:focus {
  outline: none !important;
}

i {
  cursor: pointer;
}
</style>
