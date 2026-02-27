<template>
  <v-form  @submit.prevent="signup" class="px-3 py-2">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <div >
      <label for="email">Зарегистрироваться</label>
      <v-text-field class="px-3" v-model="email" :rules="emailRules"   id="email" placeholder="email@example.com"></v-text-field>
    </div>
    <div >
      <!-- <label for="password">Придумайте пароль</label> -->
      <v-text-field class="px-3" v-model="password" type="password" id="password" placeholder="Придумайте пароль"></v-text-field>
    </div>
    <div >
      <!-- <label for="password">Повторите пароль</label> -->
      <v-text-field class="px-3" v-model="password_confirmation" :rules="confirmRules" type="password" id="password_confirmation" placeholder="Повторите пароль"></v-text-field>
    </div>
    <div class="d-flex justify-center">
      <v-btn type="submit" class="btn btn-primary my-3">Отправить</v-btn>
    </div>
    <div>

    </div>
  </v-form>
</template>

<script setup>
import { computed, getCurrentInstance, ref } from "vue"
import { useRouter } from "vue-router"
import { useLogStore } from "store.js"

const emit = defineEmits(["success"])
const router = useRouter()
const logStore = useLogStore()
const { proxy } = getCurrentInstance()

const email = ref("")
const password = ref("")
const password_confirmation = ref("")
const error = ref("")

const emailRules = [
  (v) => !!v || "E-mail необходим для регистрации",
  (v) => /.+@.+\..+/.test(v) || "E-mail введен некорректно",
]

const confirmRules = computed(() => [
  (v) => !!v || "нужно ввести пароль",
  (v) => v.length >= 5 || "Пароль должен содержать более 6 символов",
  (v) => v === password.value || "Пароли не совпадают",
])

const signupFailed = (err) => {
  error.value = (err?.response?.data?.error) || err?.data?.errors || ""
  logStore.unsetCurrentUser()
}

const signup = async () => {
  try {
    const response = await proxy.$http.plain.post("/signup", {
      email: email.value,
      password: password.value,
      password_confirmation: password_confirmation.value,
    })

    if (!response?.data?.csrf) {
      signupFailed(response)
      return
    }

    const meResponse = await proxy.$http.plain.get("/me")
    logStore.setCurrentUser(meResponse.data, response.data.csrf)
    error.value = ""
    emit("success")
    router.replace("/")
  } catch (err) {
    signupFailed(err)
  }
}
</script>

<style lang="css">
.form-signup {
  width: 70%;
  max-width: 500px;
  padding: 10% 15px;
  margin: 0 auto;
}
</style>
