<template>
  <v-container class=" py-2 " >
  <div class="list">
    <br>
 <!-- афаф{{this.users}} -->
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>Users</h3>
    <br />
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Email</th>
          <th>Статус</th>
          <!-- <th v-if="this.currentUser.role == 'admin'">Todos</th> -->
        </tr>
      </thead>
      <tbody>
        <!-- {{this.users}} -->
        <tr v-for="user in users" :key="user.id" :user="user">
          <th>{{ user.id }}</th>
          <td>{{ user.email }}</td>
          <td>{{ user.role }}</td>
<!--           <td v-if="this.currentUser.role == 'admin'">
            <i class="fa fa-list-ul"></i>
          </td> -->
        </tr>
      </tbody>
    </table>
  </div>
  </v-container>
</template>

<script>
// import AppHeader from '@/components/AppHeader'
import { mapState } from 'pinia'
import { useLogStore } from 'store.js'
export default {
  name: 'UsersList',
  data () {
    return {
      error: '',
      users: []
    }
  },
  mounted(){

  },
  created () {
    console.log("list created")
    if (this.signedIn && (this.currentUser.role == 'manager' || this.currentUser.role == 'admin')) {
      this.$http.secured.get('/admin/users')

        .then(response => { 
          console.log(response.data)
          this.users = response.data 
        })
        .catch(error => { this.setError(error, 'Something went wrong') })
    } else {
      this.$router.replace('/')
    }

  },
  computed: {
    ...mapState(useLogStore, {
      signedIn: "thissignedIn",
    }),      
    ...mapState(useLogStore, {
      currentUser: "thiscurrentUser",
    }),     
  },  
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
 
  },
 
}
</script>
<style scoped>
.list{

  height: 200px;
}
</style>