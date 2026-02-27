<template>
  <v-container class=" py-2 " >
    редактор
  </v-container>
</template>

<script>
// import AppHeader from '@/components/AppHeader'
import { mapState } from 'pinia'
import { useLogStore } from 'store.js'
export default {
  name: 'Redactor',
  data () {
    return {
      redactors: [],
      error: '',
      users: []
    }
  },
  mounted(){

  },
  created () {
 
    this.$http.plain.get('/prices')
      .then(response => { 
        this.prices = response.data 
      })
      .catch(error => { this.setError(error, 'Something went wrong') })


      this.$http.secured.get('/admin/redactors')
        .then(response => { 
          console.log(response.data)
          this.redactors = response.data 

        })
        .catch(error => this.setError(error, 'Something went wrong'))


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