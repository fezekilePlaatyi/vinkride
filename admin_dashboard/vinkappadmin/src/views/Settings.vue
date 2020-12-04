<template>
    <div>
        <nav-bar />
        <section>
            <div class="container-fluid">
                <div class="d-flex justify-content-end">
                    <div class="col-xl-5 mt-5">
                        <div class="card rounded">
                            <div class="card-body">
                                <h5 class="text-muted text-center mb-4">Adding Categories</h5>
                                <form>
                                    <div class="form-group">
                                        <input type="text" class="form-control py-2 mb-3" placeholder="Category Name">
                                        <button type="button" class="btn btn-block text-uppercase font-weight-bold text-light btn-add-blue py-2 mb-5">Add Category</button>
                                    </div>
                                </form>
                                <div class="row">
                                    <div class="col-6 mb-2">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <p class="card-text text-center font-weight-bold text-uppercase">Barber</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 mb-2">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <p class="card-text text-center font-weight-bold text-uppercase">Beautician</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 mb-2">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <p class="card-text text-center font-weight-bold text-uppercase">Mohog - R80</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-5 mt-5">
                        <div class="card rounded">
                            <div class="card-body">
                                <h5 class="text-muted text-center mb-4">Adding Skills</h5>
                                <form>
                                    <div class="form-group">
                                        <select name="" id="" class="form-control py-2 mb-3">
                                            <option value="" disabled selected>- Select a category -</option>
                                        </select>
                                        <input type="text" class="form-control py-2 mb-3" placeholder="Skill Name">
                                        <input type="text" class="form-control py-2 mb-3" placeholder="Price">
                                        <button type="button" class="btn btn-block text-uppercase font-weight-bold text-light py-2 mb-5 btn-add-blue">Add Skill</button>
                                    </div>
                                </form>
                                <div class="row">
                                    <div class="col-6 mb-2">
                                        <div class="card bg-light">
                                            <div class="card-body setting-actions">
                                                <p class="card-text text-center font-weight-bold text-uppercase">Chiskop - R120</p>
                                                <div class="setting-actions-display">
                                                    <div class="d-flex justify-content-center action-option">
                                                        <span class="mx-3 text-white">
                                                            <i class="fas fa-trash" @click.prevent="checkValue('Delete')"></i>
                                                        </span>
                                                        <span class="mx-3 text-white">
                                                            <i class="fas fa-pen" @click.prevent="checkValue('Edit')"></i>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 mb-2">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <p class="card-text text-center font-weight-bold text-uppercase">Fade - R140</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-6 mb-2">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <p class="card-text text-center font-weight-bold text-uppercase">Mohog - R80</p>
                                            </div>
                                        </div>
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
  },
  methods: {
    checkValue (val) {
      alert(val)
    }
  }
}
</script>
