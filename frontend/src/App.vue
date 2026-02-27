<template>
  <div>
    <v-app >
      <headpart></headpart>  

      <v-main>
 
        <router-view></router-view>

      </v-main>
    </v-app>    
  </div>
</template>

<script>
 import { mapState } from 'pinia'
import Headpart from './packs/components/head.vue'
import NotFound from './packs/components/404.vue';

import { useLogStore } from 'store.js'

export default {
  components: {
    'headpart': Headpart
  },
 
    data: function () {

    return {
 
    }
  },
  computed: {
 
  },  

  methods:{
 
  },
  created () {
    console.log("app.vue created")
  },
  mounted(){
    console.log("app.vue mounted")
  },

  updated () {
    console.log("app.vue updated")
  },

}
</script>

<style >

</style>