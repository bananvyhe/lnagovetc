import { computed } from "vue"
import { storeToRefs } from "pinia"
import { useLogStore } from "store.js"

export const useAdmin = () => {
  const logStore = useLogStore()
  const { currentUser } = storeToRefs(logStore)
  const isAdmin = computed(() => currentUser.value?.role === "admin")
  return { isAdmin }
}
