<template>
    <div>
        <nav-bar />
        <section v-if="unverifiedUsers != null || unverifiedUsers.length > 0">
            <div class="container-fluid">
                <div class="d-flex justify-content-end">
                    <div class="col-10">
                        <h3 class="text-muted mt-4">Pending Approvals</h3>
                        <table class="table table-striped bg-light text-center">
                            <thead>
                                <tr class="text-muted">
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Date created</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="user in unverifiedUsers" :key="user.id">
                                    <td>{{user.data().name}}</td>
                                    <td>{{user.data().email}}</td>
                                    <td>{{toDate(user.data().created_at)}}</td>
                                    <td>
                                        <router-link :to="`/user-verification/${user.id}`" class="btn btn-info btn-sm">View</router-link>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- pagination -->
                        <nav>
                            <ul class="pagination justify-content-center">
                                <li class="page-item">
                                    <a href="#" class="page-link py-2 px-3">
                                        <span>&laquo;</span>
                                    </a>
                                </li>
                                <li class="page-item active">
                                    <a href="#" class="page-link py-2 px-3">1</a>
                                </li>
                                <li class="page-item">
                                    <a href="#" class="page-link py-2 px-3">2</a>
                                </li>
                                <li class="page-item">
                                    <a href="#" class="page-link py-2 px-3">3</a>
                                </li>
                                <li class="page-item">
                                    <a href="#" class="page-link py-2 px-3">
                                        <span>&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script>
import NavBar from '@/components/NavBar'
import { mapActions, mapState } from 'vuex'
import moment from 'moment'
export default {
  data () {
    return {
      count: 1
    }
  },
  components: {
    NavBar
  },
  computed: {
    ...mapState(['unverifiedUsers'])
  },
  methods: {
    ...mapActions(['getUnverifiedUsers']),
    toDate (timestamp) {
      return moment(timestamp.toDate()).format('MMMM Do, YYYY')
    }
  },
  mounted () {
    this.getUnverifiedUsers()
  }
}
</script>
<style></style>
