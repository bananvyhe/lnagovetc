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
    meta: { title: "Контакты | Людмила Наговец", description: "Контакты и способы записи на консультацию к психологу г. Екатеринбург Людмиле Наговец." },
  },
  {
    path: "/pricel",
    name: "Prices",
    component: Prices,
    meta: { title: "Стоимость | Людмила Наговец", description: "Стоимость консультаций у психолога — психоаналитик Людмилы Наговец." },
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
      title: "Людмила Наговец   психолог — психоаналитик",
      description: "Людмила Наговец   психолог — психоаналитик. Очные и онлайн консультации.",
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

const PRIVATE_ROUTE_PREFIXES = ["/admin"]
const PRIVATE_ROUTE_PATHS = ["/Signin", "/Signup", "/todos"]

const isPrivateRoute = (path, name) => {
  if (name === "NotFound") return true
  if (PRIVATE_ROUTE_PATHS.includes(path)) return true
  return PRIVATE_ROUTE_PREFIXES.some((prefix) => path.startsWith(prefix))
}

router.afterEach((to) => {
  const title = to.meta?.title || "Людмила Наговец — психолог в Екатеринбурге"
  const description =
    to.meta?.description ||
    "Людмила Наговец — психолог в Екатеринбурге. Очные и онлайн консультации."
  const privateRoute = isPrivateRoute(to.path, to.name)
  const siteOrigin = import.meta.env.VITE_SITE_ORIGIN || "https://nagovets.ru"

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
  ensureMeta(
    'meta[name="robots"]',
    "name",
    "robots",
    privateRoute ? "noindex, nofollow, noarchive" : "index, follow",
  )

  let canonical = document.head.querySelector('link[rel="canonical"]')
  if (!canonical) {
    canonical = document.createElement("link")
    canonical.setAttribute("rel", "canonical")
    document.head.appendChild(canonical)
  }
  canonical.setAttribute("href", privateRoute ? `${siteOrigin}/` : `${siteOrigin}${to.path || "/"}`)
})

export default router
