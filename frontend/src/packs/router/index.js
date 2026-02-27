import { createRouter, createWebHistory } from "vue-router"
import Contacts from "../../contacts.vue"
import Prices from "../../prices.vue"
import Reviews from "../../reviews.vue"
import Content from "../../content.vue"
import Signin from "../components/Signin.vue"
import Signup from "../components/Signup.vue"
import List from "../components/todos/list.vue"
import NotFound from "../components/404.vue"
import UsersList from "../components/admin/users/List.vue"
import Redactor from "../components/admin/redactor.vue"

const routes = [
  { path: "/cont", name: "Contacts", component: Contacts },
  { path: "/pricel", name: "Prices", component: Prices },
  { path: "/rev", name: "Reviews", component: Reviews },
  { path: "/", name: "Content", component: Content },
  { path: "/Signup", name: "Signup", component: Signup },
  { path: "/Signin", name: "Signin", component: Signin },
  { path: "/todos", name: "List", component: List },
  { path: "/admin/use", name: "UsersList", component: UsersList },
  { path: "/admin/red", name: "Redactor", component: Redactor },
  { path: "/:pathMatch(.*)*", name: "NotFound", component: NotFound },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
