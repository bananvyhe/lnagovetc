<template>
<div>
  <v-menu v-model="menuOpen" offset-y
    :close-on-content-click="closeOnContentClick">
    <template v-slot:activator="{ props }">
      <v-btn
        color="success"
        class="mx-1 text-none profile-btn"
        size="x-small"
        variant="flat"
        v-bind="props"
      >
        <div  v-if="signedIn == true">
          Аккаунт      
        </div> 
        <div  v-if="signedIn == false">
          Войти
        </div>
      </v-btn>
    </template>
 
    <v-card elevation="2"
      class="px-2 py-2"
       min-width="244"
      max-width="474">
    <signin v-if="!signedIn && regwin == false" @success="onAuthSuccess"></signin>
    <signup v-if="!signedIn && regwin == true" @success="onAuthSuccess"></signup>  
    <div class="register d-flex justify-end" v-if="signedIn == false">

      <!-- {{this.regwin}} -->
      <v-btn
          class="my-2 align-end text-none"
        @click="regwin = !regwin"
        size="x-small"
        variant="text"
        color="primary"> 
        <div v-if="regwin == true"> 
          Войти
        </div>        
        <div v-if="regwin == false"> 
          Не зарегистрированы? 
        </div>
      </v-btn>  
    
      </div>
      <div v-if="signedIn == true" class="d-flex flex-column">
        <div  class="d-flex flex-column">
          {{ currentUser.email}}  
          <div class="px-2 py-2 d-flex flex-column">
            <router-link to="/admin/use" v-admin="isAdmin">пользователи</router-link>
            <!-- <router-link  to="/admin/red" v-if="this.currentUser.role == 'admin'">редактор</router-link>              -->
          </div>

        </div> 
        <div   class="d-flex flex-row  justify-space-between">
          <div  class="d-flex ">
            статус: {{ currentUser.role}} 
          </div>        
          <div  class="d-flex ">
            <v-btn   
              v-if="signedIn == true"
              size="x-small"
              variant="text"
              class="text-none"
              color="primary"  
              @click="signOut">выйти
            </v-btn>                
          </div>          
        </div>
      </div>
    </v-card>

  </v-menu>   
</div>
</template>

<script setup>
import { getCurrentInstance, ref } from "vue"
import { storeToRefs } from "pinia"
import { useRouter } from "vue-router"
import { useLogStore } from "store.js"
import { useAdmin } from "../../composables/useAdmin"
import Signin from "../../packs/components/Signin.vue"
import Signup from "../../packs/components/Signup.vue"

const router = useRouter()
const logStore = useLogStore()
const { proxy } = getCurrentInstance()
const { isAdmin } = useAdmin()

const { currentUser, signedIn } = storeToRefs(logStore)

const regwin = ref(false)
const menuOpen = ref(false)
const closeOnContentClick = ref(false)

const onAuthSuccess = () => {
  regwin.value = false
  menuOpen.value = false
}

const signOut = async () => {
  try {
    await proxy.$http.secured.delete("/signin")
    logStore.unsetCurrentUser()
    regwin.value = false
    menuOpen.value = false
    router.replace("/")
  } catch (error) {
    proxy.setError?.(error, "Cannot sign out")
  }
}
</script>

<style lang="css">
.register{
  cursor: pointer;
}
.profile-btn {
  min-height: 28px;
  padding-left: 10px;
  padding-right: 10px;
}
.form-signin {
  width: 70%;
  max-width: 500px;
  padding: 10% 15px;
  margin: 0 auto;
}
</style>
