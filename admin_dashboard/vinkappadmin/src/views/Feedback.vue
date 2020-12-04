<template>
    <div>
        <nav-bar />
        <section>
            <div class="container-fluid">
                <div class="d-flex justify-content-end">
                    <div class="col-10">
                        <h4 class="text-muted mt-5">User Feedback</h4>
                        <div id="accordion">
                            <div class="card">
                                <div class="card-header">
                                    <button class="btn btn-block bg-secondary text-light text-left" data-toggle="collapse" data-target="#collapseOne">
                                        <img src="../assets/images/cust1.jpeg" width="50" class="mr-3 rounded" />
                                        John submitted feedback
                                    </button>
                                </div>
                                <div class="collapse show" id="collapseOne" data-parent="#accordion">
                                    <div class="card-body">
                                        Lorem, ipsum dolor sit amet consectetur
                                        adipisicing elit. Reiciendis earum modi
                                        delectus fugiat consectetur eaque harum
                                        obcaecati, saepe id vitae, dolore aliquam!
                                        Quos, doloribus quisquam.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <button class="btn btn-block bg-secondary text-light text-left" data-toggle="collapse" data-target="#collapseTwo">
                                        <img src="../assets/images/cust2.jpeg" width="50" class="mr-3 rounded" />
                                        Mark submitted feedback
                                    </button>
                                </div>
                                <div class="collapse" id="collapseTwo" data-parent="#accordion">
                                    <div class="card-body">
                                        Lorem, ipsum dolor sit amet consectetur
                                        adipisicing elit. Reiciendis earum modi
                                        delectus fugiat consectetur eaque harum
                                        obcaecati, saepe id vitae, dolore aliquam!
                                        Quos, doloribus quisquam.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <button class="btn btn-block bg-secondary text-light text-left" data-toggle="collapse" data-target="#collapseThree">
                                        <img src="../assets/images/cust3.jpeg" width="50" class="mr-3 rounded" />
                                        Monica submitted feedback
                                    </button>
                                </div>
                                <div class="collapse" id="collapseThree" data-parent="#accordion">
                                    <div class="card-body">
                                        Lorem, ipsum dolor sit amet consectetur
                                        adipisicing elit. Reiciendis earum modi
                                        delectus fugiat consectetur eaque harum
                                        obcaecati, saepe id vitae, dolore aliquam!
                                        Quos, doloribus quisquam.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <button class="btn btn-block bg-secondary text-light text-left" data-toggle="collapse" data-target="#collapseFour">
                                        <img src="../assets/images/cust4.jpeg" width="50" class="mr-3 rounded" />
                                        Vivien submitted feedback
                                    </button>
                                </div>
                                <div class="collapse" id="collapseFour" data-parent="#accordion">
                                    <div class="card-body">
                                        Lorem, ipsum dolor sit amet consectetur
                                        adipisicing elit. Reiciendis earum modi
                                        delectus fugiat consectetur eaque harum
                                        obcaecati, saepe id vitae, dolore aliquam!
                                        Quos, doloribus quisquam.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <button class="btn btn-block bg-secondary text-light text-left" data-toggle="collapse" data-target="#collapseFive">
                                        <img src="../assets/images/cust5.jpeg" width="50" class="mr-3 rounded" />
                                        Nick submitted feedback
                                    </button>
                                </div>
                                <div class="collapse" id="collapseFive" data-parent="#accordion">
                                    <div class="card-body">
                                        Lorem, ipsum dolor sit amet consectetur
                                        adipisicing elit. Reiciendis earum modi
                                        delectus fugiat consectetur eaque harum
                                        obcaecati, saepe id vitae, dolore aliquam!
                                        Quos, doloribus quisquam.
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <button class="btn btn-block bg-secondary text-light text-left" data-toggle="collapse" data-target="#collapseSix">
                                        <img src="../assets/images/cust6.jpeg" width="50" class="mr-3 rounded" />
                                        Ann submitted feedback
                                    </button>
                                </div>
                                <div class="collapse" id="collapseSix" data-parent="#accordion">
                                    <div class="card-body">
                                        Lorem, ipsum dolor sit amet consectetur
                                        adipisicing elit. Reiciendis earum modi
                                        delectus fugiat consectetur eaque harum
                                        obcaecati, saepe id vitae, dolore aliquam!
                                        Quos, doloribus quisquam.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>
<script>
import NavBar from '@/components/NavBar'
export default {
  components: {
    NavBar
  }
}
</script>
