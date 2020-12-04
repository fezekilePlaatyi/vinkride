<template>
    <div class="loginbody">
        <div class="loginbox">
            <img src="/src/assets/images/vink_icon.png" class="avatar" />
            <h1>Login Here</h1>
            <form @submit.prevent="loginSubmit()">
                <p>Username</p>
                <input type="text" v-model="form.email" placeholder="Enter Username" />
                <p>Password</p>
                <input type="password" v-model="form.password" placeholder="Enter Password" />
                <input type="submit" name="" value="Login" />
                <!--   <a href="#">Lost your password?</a><br>
                <a href="#">Don't have an account?</a> -->
            </form>
        </div>
    </div>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  data () {
    return {
      // eslint-disable-next-line no-undef
      form: new Form({
        email: '',
        password: ''
      }
      )
    }
  },
  methods: {
    loginSubmit () {
      if (this.form.email === '') {
        // eslint-disable-next-line no-undef
        showError('Provide email')
        // eslint-disable-next-line no-useless-return
        return
      }

      if (this.form.password === '') {
        // eslint-disable-next-line no-undef
        showError('Provide password')
        // eslint-disable-next-line no-useless-return
        return
      }
      this.login(this.form)
    },
    ...mapActions(['login'])
  }
}
</script>
