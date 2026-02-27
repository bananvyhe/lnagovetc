import axios from "axios"
import { useLogStore } from "store.js"
import router from "../../router"
const API_URL = import.meta.env.VITE_API_URL || "http://localhost:3000"
// const API_URL = window.location.href 
// const API_URL = 'http://localhost:3000'
// export default axios.create({
//   baseURL: API_URL,
//   headers: {
//     'Content-Type': 'application/json'
//   }
// })

const securedAxiosInstance = axios.create({ 
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    // 'Access-Control-Allow-Origin': '*',
    // 'Access-Control-Allow-Headers': '*',
    'Content-Type': 'application/json',
  }
})

const plainAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    // 'Access-Control-Allow-Origin': '*',
    // 'Access-Control-Allow-Headers': '*',
    'Content-Type': 'application/json',
  }
})
 
securedAxiosInstance.interceptors.request.use(config => {
  const method = config.method.toUpperCase()
  if (method !== 'OPTIONS' && method !== 'GET') {
    const logStore = useLogStore()
    console.log(logStore.thiscsrf)
    config.headers = {
      ...config.headers,
      'X-CSRF-TOKEN': logStore.thiscsrf
    }
  }
  return config
})

securedAxiosInstance.interceptors.response.use(null, error => {
  if (error.response && error.response.config && error.response.status === 401) {
    const logStore = useLogStore()
    // In case 401 is caused by expired access cookie - we'll do refresh request
    return plainAxiosInstance.post('/refresh', {}, { headers: { 'X-CSRF-TOKEN': logStore.thiscsrf } })
      .then(response => {
        logStore.refresh(response.data.csrf) 
        // localStorage.csrf = response.data.csrf
        // localStorage.signedIn = true
        // And after successful refresh - repeat the original request
        let retryConfig = error.response.config
        retryConfig.headers['X-CSRF-TOKEN'] = logStore.thiscsrf
        return plainAxiosInstance.request(retryConfig)
      }).catch(error => {
        // delete localStorage.csrf
        // delete localStorage.signedIn
        const logStore = useLogStore();
        logStore.unsetCurrentUser()
        // redirect to root without full page reload
        router.replace('/')
        return Promise.reject(error)
      })
  } else {
    return Promise.reject(error)
  }
})

export { securedAxiosInstance, plainAxiosInstance }
