import { createApp } from "vue"
import { reactive } from "vue"
import { createPinia } from "pinia"
import piniaPluginPersistedstate from "pinia-plugin-persistedstate"
import Toast from "vue-toastification"
import "vuetify/styles"
import { createVuetify } from "vuetify"
import * as components from "vuetify/components"
import * as directives from "vuetify/directives"
import "vue-toastification/dist/index.css"
import App from "./App.vue"
import router from "./packs/router"
import { securedAxiosInstance, plainAxiosInstance } from "./packs/backend/axios"
import "./style.css"
import "vue-datepicker-next/index.css"

const app = createApp(App)

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)
const vuetify = createVuetify({
  components,
  directives,
})

const breakpoint = reactive({
  xs: false,
  sm: false,
  md: true,
  lg: false,
  xl: false,
})

const syncBreakpoint = () => {
  const w = window.innerWidth
  breakpoint.xs = w < 600
  breakpoint.sm = w >= 600 && w < 960
  breakpoint.md = w >= 960 && w < 1264
  breakpoint.lg = w >= 1264 && w < 1904
  breakpoint.xl = w >= 1904
}
syncBreakpoint()
window.addEventListener("resize", syncBreakpoint)

const goTo = (target, options = {}) => {
  const offset = Number(options.offset || 0)
  const behavior = options.behavior || "smooth"

  if (typeof target === "number") {
    window.scrollTo({ top: Math.max(0, target - offset), behavior })
    return
  }

  const el = typeof target === "string" ? document.querySelector(target) : target
  if (!el || typeof el.getBoundingClientRect !== "function") return

  const top = window.scrollY + el.getBoundingClientRect().top - offset
  window.scrollTo({ top: Math.max(0, top), behavior })
}

app.use(pinia)
app.use(router)
app.use(vuetify)
app.use(Toast, {})
app.config.globalProperties.$http = {
  secured: securedAxiosInstance,
  plain: plainAxiosInstance,
}
app.config.globalProperties.$vuetify = { breakpoint, goTo }
app.mixin({
  methods: {
    setError(error, message) {
      console.error(message, error)
      if (this.$toast && typeof this.$toast.error === "function") {
        this.$toast.error(message)
      }
    },
  },
})

app.mount("#app")
