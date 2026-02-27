<template>
  <v-form   @submit.prevent="signin" class="px-3 py-2">
     <div for="email" class="mb-2">Войти на сайт</div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <v-text-field  class="px-2 pt-2" v-model="email"  :rules="emailRules" type="email" filled id="email" placeholder="email@example.ru">
        </v-text-field>
        <!-- <label for="password">Пароль</label> -->
        <v-text-field class="px-2" v-model="password" type="password" filled id="password" placeholder="Password"></v-text-field>
        <div class="d-flex justify-center">
           <v-btn type="submit" class="btn btn-primary mb-1">Войти</v-btn>
        </div>
     
      <div>
    </div>
  </v-form>
</template>

<script setup>
import { getCurrentInstance, ref } from "vue"
import { useRouter } from "vue-router"
import { useLogStore } from "store.js"

const emit = defineEmits(["success"])
const router = useRouter()
const logStore = useLogStore()
const { proxy } = getCurrentInstance()

const email = ref("")
const password = ref("")
const error = ref("")

const emailRules = [
  (v) => !!v || "E-mail необходим для авторизации",
  (v) => /.+@.+\..+/.test(v) || "E-mail введен некорректно",
]

const signinFailed = (err) => {
  error.value = (err?.response?.data?.error) || ""
  logStore.unsetCurrentUser()
}

const signin = async () => {
  try {
    const response = await proxy.$http.plain.post("/signin", {
      email: email.value,
      password: password.value,
    })

    if (!response?.data?.csrf) {
      signinFailed(response)
      return
    }

    const meResponse = await proxy.$http.plain.get("/me")
    logStore.setCurrentUser(meResponse.data, response.data.csrf)
    error.value = ""
    emit("success")
    router.replace("/")
  } catch (err) {
    signinFailed(err)
  }
}
</script>

<style lang="css">
input:-webkit-autofill { 
    -webkit-background-clip: text;
}
.form-signin {
  /*width: 70%;*/
  /*max-width: 500px;*/
  /*padding: 10% 15px;*/
  /*margin: 0 auto;*/
}
</style>
