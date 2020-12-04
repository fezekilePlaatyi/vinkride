<template>
    <div class="container mt-4">
        <div v-if="user != null">
            <div class="row">
                <div class="col-4">
                    <div class="card border-0 shadow-lg rounded-0">
                        <div class="card-header bg-white border-0 shadow-sm py-3">
                            <div class="d-flex align-items-baseline">
                                <i class="fas fa-arrow-left mr-2" @click="$router.go(-1)"></i>
                                <div class="d-flex align-items-baseline">
                                    <h5>Profile</h5>
                                    <p :class="user.isVerified?'badge-success':'badge-danger'" class="ml-2 font-weight-light badge p-1">{{user.isVerified ? "Verified" : "Unverified"}}</p>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <img :src="'profile_pic' in user?user.profile_pic:'https://picsum.photos/200/300'" alt="" class="profile-pic">
                            </div>
                            <hr>
                            <div>
                                <div class="text-center">
                                    {{user.name}}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-8">
                    <div class="card border-0 shadow-lg h-100 rounded-0">
                        <div class="card-header bg-white border-0 shadow-sm py-4">
                            <div class="d-flex justify-content-between">
                                <div class="d-flex">
                                    <div class="mx-2">
                                        <i class="fas fa-phone text-danger"></i>
                                        <span class="ml-1">{{user.phone_number}}</span>
                                    </div>
                                    <div class="mx-2">
                                        <i class="fas fa-envelope text-danger"></i>
                                        <span class="ml-1">{{user.email}}</span>
                                    </div>
                                </div>
                                <div class="d-flex">
                                    <div class="mx-2">
                                        <a :href="'instagram_link' in user? user.instagram_link: '#'" target="_blank">
                                            <i class="fab fa-instagram text-danger"></i>
                                        </a>
                                    </div>
                                    <div class="mx-2">
                                        <a :href="'facebook_link' in user? user.facebook_link: '#'" target="_blank">
                                            <i class="fab fa-facebook text-danger"></i>
                                        </a>
                                    </div>
                                    <div class="mx-2">
                                        <a :href="'twitter_link' in user? user.twitter_link: '#'" target="_blank">
                                            <i class="fab fa-twitter text-danger"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- <h6 class="text-center py-1 text-muted">Supporting Documents</h6> -->
                            <div class="row ml-2">
                                <div class="col-6">
                                    <div class="mb-3">
                                        <i class="fas fa-id-card"></i> ID
                                    </div>
                                    <img :src="'id_copy' in user?user.id_copy: '/src/assets/images/missing_image.png'" alt="" class="supporting-pics">
                                </div>
                                <div class="col-6">
                                    <div class="mb-3">
                                        <i class="fas fa-id-card-alt"></i> Licence
                                    </div>
                                    <img src="../assets/images/missing_image.png" alt="" class="supporting-pics">
                                </div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-center m-3" v-if="!user.isVerified">
                            <button class="btn btn-success w-100  mx-3" @click.prevent="approve()">Approve</button>
                            <button class="btn btn-danger w-100 mx-3" data-toggle="modal" data-target="#exampleModalCenter" @click.prevent="disapprove()">Disapprove</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row mx-0 mt-4">
                <div class="card w-100 border-0 rounded-0">
                    <div class="card-header border-0 bg-white shadow-sm">
                        <div class="d-flex justify-content-between align-items-baseline">
                            <div class="d-flex">
                                <p class="border p-2 rounded border-primary text-primary">MGOQI 1 EC</p>
                            </div>
                            <h6>{{user.address}}</h6>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <div><img src="../assets/images/default_car.jpg" class="w-25"></div>
                            </div>
                            <div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div v-else>
            <h2 class="text-muted font-weight-bold">Loading...</h2>
        </div>
        <!-- Modal -->
        <div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <h6 class="modal-title" id="exampleModalLongTitle">Why you disapprove this user?</h6>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true" class="text-danger">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body border-0">
                        <textarea class="form-control" v-model="form.message" placeholder="Leave a user a message"></textarea>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light text-dark" @click.prevent="closeModal()" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-success" @click.prevent="verifyUserSubmit()">Send Email</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { mapActions, mapState } from 'vuex'
export default {
  data () {
    return {
      // eslint-disable-next-line no-undef
      form: new Form({
        id: this.$route.params.id,
        name: '',
        email: '',
        isApproved: false,
        subject: '',
        message: ''
      })
    }
  },
  computed: {
    ...mapState(['user'])
  },
  methods: {
    ...mapActions(['getUser', 'verifyUser']),
    verifyUserSubmit () {
      if (this.form.message === '') {
        // eslint-disable-next-line no-undef
        showError('Message is required')
        // eslint-disable-next-line no-useless-return
        return
      }

      this.verifyUser(this.form)
    },
    approve () {
      this.form.email = this.user.email
      this.form.name = this.user.name
      this.form.isApproved = true
      this.form.message = 'Your account has been approved, you can now use the app!!'
      this.form.subject = 'Account Approved'
      this.verifyUserSubmit()
    },
    disapprove () {
      this.form.email = this.user.email
      this.form.name = this.user.name
      this.form.subject = 'Account not Approved'
      this.form.isApproved = false
    },
    closeModal () {
      this.form.isApproved = false
      this.form.message = ''
    }
  },
  mounted () {
    this.getUser(this.$route.params.id)
  }
}
</script>
