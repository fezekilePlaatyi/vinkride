<template>
    <nav-bar />
    <section>
        <div class="container-fluid">
            <div class="d-flex justify-content-end">
                <div class="col-xl-10 col-10 mt-4">
                    <h3 class="text-muted mb-3">Recent Payments</h3>
                    <table class="table table-dark table-hover text-center">
                        <thead>
                            <tr class="text-muted">
                                <th>#</th>
                                <th>Name</th>
                                <th>Revenue</th>
                                <th>Services</th>
                                <th>Email</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>1</th>
                                <td>Zizo Ndziba</td>
                                <td>R2000</td>
                                <td>5</td>
                                <td>name@email.com</td>
                                <td><span class="badge badge-success w-75 py-2">Approved</span></td>
                            </tr>
                            <tr>
                                <th>2</th>
                                <td>Zizu Mpangeni</td>
                                <td>R2000</td>
                                <td>5</td>
                                <td>name@email.com</td>
                                <td><span class="badge badge-success w-75 py-2">Approved</span></td>
                            </tr>
                            <tr>
                                <th>3</th>
                                <td>Mxhosa Ngwane</td>
                                <td>R2000</td>
                                <td>5</td>
                                <td>name@email.com</td>
                                <td><span class="badge badge-danger w-75 py-2">Pending</span></td>
                            </tr>
                            <tr>
                                <th>4</th>
                                <td>Jane Winky</td>
                                <td>R2000</td>
                                <td>5</td>
                                <td>name@email.com</td>
                                <td><span class="badge badge-danger w-75 py-2">Pending</span></td>
                            </tr>
                            <tr>
                                <th>5</th>
                                <td>Abongile Ngwane</td>
                                <td>R2000</td>
                                <td>5</td>
                                <td>name@email.com</td>
                                <td><span class="badge badge-success w-75 py-2">Approved</span></td>
                            </tr>
                            <tr>
                                <th>6</th>
                                <td>Asavela Boja</td>
                                <td>R2000</td>
                                <td>5</td>
                                <td>name@email.com</td>
                                <td><span class="badge badge-danger w-75 py-2">Pending</span></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- pagination -->
                    <nav>
                        <ul class="pagination justify-content-center">
                            <li class="page-item">
                                <a href="#" class="page-link py-2 px-3">
                                <span>Previous</span>
                                </a>
                            </li>
                            <li class="page-item active">
                                <a href="#" class="page-link py-2 px-3">
                                1
                                </a>
                            </li>
                            <li class="page-item">
                                <a href="#" class="page-link py-2 px-3">
                                2
                                </a>
                            </li>
                            <li class="page-item">
                                <a href="#" class="page-link py-2 px-3">
                                3
                                </a>
                            </li>
                            <li class="page-item">
                                <a href="#" class="page-link py-2 px-3">
                                <span>Next</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                    <!-- end of pagination -->
                </div>
            </div>

        </div>
    </section>
</template>
<script>
import NavBar from '@/components/NavBar'
export default {
  components: {
    NavBar
  }
}
</script>
