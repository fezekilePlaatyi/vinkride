<template>
  <nav class="navbar navbar-expand-md navbar-light mb-5">
    <button class="navbar-toggler ml-auto mb-2 bg-light" type="button" data-toggle="collapse" data-target="#myNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="myNavbar">
      <div class="container-fluid">
        <div class="row">
          <!-- sidebar -->
          <div class="col-xl-2 col-lg-3 col-md-4 sidebar fixed-top">
            <a href="#" class="navbar-brand text-white d-block mx-auto text-center py-3 mb-4 bottom-border">Vink Administration</a>
            <div class="bottom-border pb-3">
              <img src="../assets/images/vink_icon.png" width="50" class="rounded-circle mr-3">
              <a href="#" class="text-white">{{admin != null ? admin.data().name: 'Name Surname'}}</a>
            </div>
            <ul class="navbar-nav flex-column mt-4">
              <li class="nav-item">
                <router-link to="/dashboard" class="nav-link text-white p-3 mb-2 current d-flex justify-content-start"><i class="fas fa-home text-light fa-lg mr-3"></i>Dashboard</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/analytics" class="nav-link text-white p-3 mb-2 sidebar-link d-flex justify-content-start"><i class="fas fa-chart-line text-light fa-lg mr-3"></i>Analytics</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/admin" class="nav-link text-white p-3 mb-2 sidebar-link"><i class="fas fa-user-cog text-light fa-lg mr-3"></i>Admin</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/feedback" class="nav-link text-white p-3 mb-2 sidebar-link d-flex justify-content-start"><i class="fas fa-envelope text-light fa-lg mr-3"></i>Feedback</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/v-store" class="nav-link text-white p-3 mb-2 sidebar-link d-flex justify-content-start"><i class="fas fa-shopping-cart text-light fa-lg mr-3"></i>vStore</router-link>
              </li>
              <!--          <li class="nav-item"><router-link to="#" class="nav-link text-white p-3 mb-2 sidebar-link"><i class="fas fa-chart-bar text-light fa-lg mr-3"></i>Charts</router-link></li> -->
              <li class="nav-item">
                <router-link to="/revenue-split" class="nav-link text-white p-3 mb-2 sidebar-link d-flex justify-content-start"><i class="fas fa-table text-light fa-lg mr-3"></i>Revenue Split</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/settings" class="nav-link text-white p-3 mb-2 sidebar-link d-flex justify-content-start"><i class="fas fa-wrench text-light fa-lg mr-3"></i>Settings</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/documentation" class="nav-link text-white p-3 mb-2 sidebar-link d-flex justify-content-start"><i class="fas fa-file-alt text-light fa-lg mr-3"></i>Documentation</router-link>
              </li>
            </ul>
          </div>
          <div class="col-xl-10 col-lg-9 col-md-8 ml-auto bg-dark fixed-top py-2 top-navbar">
            <div class="row align-items-center">
              <div class="col-md-4">
                <h4 class="text-light text-uppercase mb-0">Dashboard</h4>
              </div>
              <div class="col-md-5">
                <form>
                  <div class="input-group">
                    <input type="text" class="form-control search-input" placeholder="Search...">
                    <button type="button" class="btn btn-white search-button"><i class="fas fa-search text-danger"></i></button>
                  </div>
                </form>
              </div>
              <div class="col-md-3">
                <ul class="navbar-nav">
                  <li class="nav-item icon-parent"><a href="#" class="nav-link icon-bullet"><i class="fas fa-comments text-muted fa-lg"></i></a></li>
                  <li class="nav-item icon-parent"><a href="#" class="nav-link icon-bullet"><i class="fas fa-bell text-muted fa-lg"></i></a></li>
                  <li class="nav-item ml-md-auto"><a href="" class="nav-link" @click.prevent="logOut"><i class="fas fa-sign-out-alt text-danger fa-lg"></i></a></li>
                </ul>
              </div>
            </div>
          </div>
          <!-- end of top-nav -->
        </div>
      </div>
    </div>
  </nav>
</template>
<script>
import { mapActions, mapState } from 'vuex'
export default {
  computed: {
    ...mapState('admin', ['admin'])
  },
  methods: {
    ...mapActions(['logOut']),
    ...mapActions('admin', ['getCurrentAdmin'])
  },
  mounted () {
    this.getCurrentAdmin()
  }
}
</script>
