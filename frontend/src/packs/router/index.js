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
  {
    path: "/cont",
    name: "Contacts",
    component: Contacts,
    meta: { title: "Контакты | Людмила Наговец", description: "Контакты и способы записи на консультацию психолога-психоаналитика Людмилы Наговец." },
  },
  {
    path: "/pricel",
    name: "Prices",
    component: Prices,
    meta: { title: "Стоимость | Людмила Наговец", description: "Стоимость консультаций психолога-психоаналитика Людмилы Наговец." },
  },
  {
    path: "/rev",
    name: "Reviews",
    component: Reviews,
    meta: { title: "Отзывы | Людмила Наговец", description: "Отзывы о консультациях Людмилы Наговец." },
  },
  {
    path: "/",
    name: "Content",
    component: Content,
    meta: {
      title: "Людмила Наговец — психолог-психоаналитик",
      description: "Психолог-психоаналитик Людмила Наговец. Очные и онлайн консультации.",
    },
  },
  { path: "/Signup", name: "Signup", component: Signup, meta: { title: "Регистрация | Людмила Наговец" } },
  { path: "/Signin", name: "Signin", component: Signin, meta: { title: "Вход | Людмила Наговец" } },
  { path: "/todos", name: "List", component: List, meta: { title: "Список задач | Людмила Наговец" } },
  { path: "/admin/use", name: "UsersList", component: UsersList, meta: { title: "Админ: пользователи | Людмила Наговец" } },
  { path: "/admin/red", name: "Redactor", component: Redactor, meta: { title: "Админ: редактор | Людмила Наговец" } },
  { path: "/:pathMatch(.*)*", name: "NotFound", component: NotFound, meta: { title: "Страница не найдена | Людмила Наговец" } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.afterEach((to) => {
  const title = to.meta?.title || "Людмила Наговец — психолог-психоаналитик"
  const description =
    to.meta?.description ||
    "Психолог-психоаналитик Людмила Наговец. Очные и онлайн консультации."

  document.title = title

  const ensureMeta = (selector, attrName, attrValue, content) => {
    let el = document.head.querySelector(selector)
    if (!el) {
      el = document.createElement("meta")
      el.setAttribute(attrName, attrValue)
      document.head.appendChild(el)
    }
    el.setAttribute("content", content)
  }

  ensureMeta('meta[name="description"]', "name", "description", description)
  ensureMeta('meta[property="og:title"]', "property", "og:title", title)
  ensureMeta('meta[property="og:description"]', "property", "og:description", description)
  ensureMeta('meta[property="og:type"]', "property", "og:type", "website")
  ensureMeta('meta[name="twitter:card"]', "name", "twitter:card", "summary_large_image")
  ensureMeta('meta[name="twitter:title"]', "name", "twitter:title", title)
  ensureMeta('meta[name="twitter:description"]', "name", "twitter:description", description)

  let canonical = document.head.querySelector('link[rel="canonical"]')
  if (!canonical) {
    canonical = document.createElement("link")
    canonical.setAttribute("rel", "canonical")
    document.head.appendChild(canonical)
  }
  canonical.setAttribute("href", `https://nagovets.ru${to.fullPath || "/"}`)
})

export default router
