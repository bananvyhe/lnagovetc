   <template>  
    <div>
      <v-app-bar dense fixed flat hide-on-scroll rounded color="transparent" class="appbar">
        <v-container class= "px-1 ">
          <div class="d-flex d-sm-flex " > 
            <v-hover>
              <template v-slot:default="{ isHovering, props }">
                <div class="menu-toggle" >
                  <v-btn v-bind="props" @click="drawer = true"
                    size="small"
                    variant="flat"
                    class="text-none"
                    color="primary">
                    <v-icon  class=" ">
                      {{mdiMenu}}
                    </v-icon>
                    меню
                  </v-btn>
                </div>
              </template>
            </v-hover>
            <v-spacer></v-spacer>
            <div class="d-flex align-center">
              <!-- {{this.signedIn}} -->
              <!-- <div v-if="this.signedIn == true" > -->
              <profile class="d-flex align-center"></profile>
              <!-- </div>   -->
              <!-- {{this.signedIn}} -->
              <div v-if="signedIn == false">
                <!-- <router-link class="mx-1" to="/Signup">Регистрация</router-link> -->
                <!-- <router-link class="mx-2 pr-1" to="/Signin">Войти</router-link> -->
              </div>          
            </div>

            <div class="d-flex align-center">
              <v-card outlined class="desktop-menu d-flex menu mr-2">
                <div  v-for="(item, index) in parts">
                  <v-btn
                    @click="handler(item.name, item.classname)"
                    size="x-small"
                    variant="text"
                    color="primary">
                    {{item.name}}
                  </v-btn> 
                </div>  
              </v-card> 
            </div>
            <v-dialog
              v-model="dialog"
              width="500">
              <template v-slot:activator="{ props }" >
                <v-btn
                  size="small"
                  color="primary"
                  variant="flat"
                  v-bind="props">
                  Записаться
                </v-btn>
              </template>
              <v-card>
                <v-form
                  class="mx-4 pt-3"
                  ref="form"
                  v-model="valid"
                  lazy-validation>
                  <v-text-field
                    v-model="name"
                    :counter="45"
                    :rules="nameRules"
                    label="Как к вам обращаться?"
                    required>
                  </v-text-field>

                  <div class="my-2">
                  </div>

                  <v-text-field
                    class="mb-2"
                    v-model="phone"
                    label="Номер телефона">
                  </v-text-field>
                  <v-textarea
                    class="mt-3"
                    v-model="text"
                    filled
                    name="input-7-4"
                    label="Задайте вопрос"
                    value="">
                  </v-textarea>
                  <div class="d-flex justify-center flex-column">
                    <div class="mb-1 " style="text-align: center;">
                      Встречи проводятся очно или онлайн через мессенджеры:
                    </div>
                    <div class="d-flex flex-row justify-center">
                      <a href="https://web.telegram.org/"  target="_blank"><div class="telg mr-2"></div></a>
                      <a href="https://skype.com/"  target="_blank"><div class="skype mr-2"></div></a>
                      <a href="https://www.whatsapp.com/"  target="_blank"><div class="whatsapp mr-2"></div></a>
                      <a href="https://www.viber.com//"  target="_blank"><div class="viber mr-2"></div></a>
                    </div>              
                  </div>
 
                  <div class="d-flex justify-end">
                    <v-btn
                      class="my-2"
                      color="primary"
                      variant="text"
                      @click="meshandl()">
                      Отправить
                    </v-btn>  
                  </div>
                </v-form>
                <v-card-actions>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </div>
        </v-container>
      </v-app-bar> 
      <v-navigation-drawer
        v-model="drawer" 
        fixed
        temporary>
        <v-list
          nav
          dense>
          <div
            class="v-list-group"
            :data-group="group">
            <div v-for="(item, index) in parts"> 
              <v-list-item>
                <v-list-item-title locale="ar-SA" ref="button" @click="handler(item.name, item.classname)"> <h3>{{item.name}}</h3> </v-list-item-title>
              </v-list-item>
            </div>
          </div>
        </v-list>
      </v-navigation-drawer>
      <v-container class="main px-0 pt-0">
        <div class="headsite">
          <div class="d-none   d-md-flex head1"></div>
 
            <div class="titleb  ">
              <router-link  to="/" >
                <div>
                  <div class="d-none d-sm-flex ludmila"></div>
                  <div class="d-none d-sm-flex nagb nagovets"></div>                
                </div>
              </router-link>
              <!-- <div class="d-none d-sm-flex  subti"> ПСИХОЛОГ - ПСИХОАНАЛИТИК</div> -->
              <div class="d-none d-sm-flex  subti flex-row  "> психолог - психоаналитик 
                <div class="subti-phone" style="text-align: center;">
                  <a class="subti-phone-link" :href="'tel:'+ tel" >
                  тел. {{tel}}
                  </a>







                </div>
              </div>



              
            </div>
 
            <div class="titles d-flex d-sm-none"> 
              <div class="ludmila  "></div>
              <div class="nagovets  nags"></div>
              <div class="bgdfa   "> </div>
              <div class="bgdfb  "> </div>
              <div class=" subti flex-row  "> психолог–психоаналитик<br><div class="pb-1 subti-phone" style="text-align: center;">
                  <a class="subti-phone-link" :href="'tel:'+ tel" >тел. {{tel}}</a>
              </div> 
            </div>

            </div>       

            <div class="head3">
              <div class="frontclouds "></div>
 
            </div>
          </div>  
                  <div class="posred" v-admin="isAdmin">
                    <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                      <template v-slot:activator="{ props }">
                        <v-btn
                          class="ma-2"
                          color="primary"
                          size="x-small"
                          variant="flat"
                          @click="gettel()"
                          v-bind="props">
                         ред
                        </v-btn> 
                      </template>
                        <v-card elevation="2"
                           min-width="344"
                          max-width="874">
                          <v-form>    
                            <v-col
                              cols="12">
                              <v-textarea
                              filled
                                v-model="tel"
                                label="">
                              </v-textarea>
                            </v-col>

                            <div class="d-flex justify-end">
                              <v-btn
                                class="ma-2"
                                color="success"
                                @click="telitem(10)"
                                size="small">
                                сохранить
                              </v-btn>
                            </div>                                                  
                          </v-form>
                        </v-card>                    
                      </v-menu>
                    </div>
        </v-container>
      </div>
    </template>
<script setup>
import { getCurrentInstance, nextTick, onMounted, ref } from "vue"
import { storeToRefs } from "pinia"
import { useRouter } from "vue-router"
import { useLogStore } from "store.js"
import { useAdmin } from "../../composables/useAdmin"
import Profile from "../../packs/components/Profile.vue"
import gsap from "gsap"
import { mdiMenu } from "@mdi/js"

const router = useRouter()
const logStore = useLogStore()
const { signedIn } = storeToRefs(logStore)
const { isAdmin } = useAdmin()
const { proxy } = getCurrentInstance()

const closeOnContentClick = ref(false)
const tel = ref("+7(919) 381 4826")
const text = ref("")
const time1 = ref(null)
const time2 = ref(null)
const phone = ref("")
const valid = ref(true)
const name = ref("")
const dialog = ref(false)
const parts = ref([
  { name: "Обо мне", classname: "#about_block" },
  { name: "Образование", classname: ".know_block" },
  { name: "Как проходит консультация?", classname: ".konsultBlock" },
  { name: "Отзывы", classname: ".rev_block" },
  { name: "Стоимость", classname: ".price_block" },
  { name: "Контакты", classname: ".contact_block" },
])
const drawer = ref(false)
const group = ref(null)

const nameRules = [
  (v) => !!v || "Ваше имя?",
  (v) => (v && v.length <= 45) || "Вы превысили лимит 45 знаков",
]

const gettel = async () => {
  try {
    const response = await proxy.$http.plain.get("/contacts")
    tel.value = response?.data?.[0]?.tel || tel.value
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const telitem = async () => {
  try {
    await proxy.$http.secured.post("/savecontitem", { id: 1, tel: tel.value })
    await gettel()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const meshandl = async () => {
  dialog.value = false
  try {
    await proxy.$http.plain.post("/mesa", {
      name: name.value,
      phone: phone.value,
      text: text.value,
      data: time1.value,
      time: time2.value,
    })

    proxy.$toast("Спасибо, ваше сообщение отправлено.", {
      position: "bottom-right",
      timeout: 5000,
      closeOnClick: true,
      pauseOnFocusLoss: true,
      pauseOnHover: true,
      draggable: true,
      draggablePercent: 0.6,
      showCloseButtonOnHover: false,
      hideProgressBar: true,
      closeButton: "button",
      icon: true,
      rtl: false,
    })
  } catch (_error) {
    // preserve previous behavior: no toast on send failure
  }
}

const blinkup = (selector) => {
  if (!selector || typeof selector !== "string" || !document.querySelector(selector)) return
  gsap.set(selector, { scale: 1 })
  gsap
    .timeline()
    .to(selector, {
      x: -7,
      delay: 0.2,
      duration: 0.6,
      ease: "elastic.in",
    })
    .to(selector, {
      scale: 1,
      x: 0,
      duration: 0.6,
      ease: "elastic.out",
    })
}

const handler = async (label, selector) => {
  let offs = 18
  if (label === "Обо мне") offs = 35

  let href = "/"
  if (label === "Отзывы") href = "/rev"
  else if (label === "Стоимость") href = "/pricel"
  else if (label === "Контакты") href = "/cont"

  await router.replace(href)
  await nextTick()

  const target = typeof selector === "string" ? document.querySelector(selector) : null
  if (target && typeof target.getBoundingClientRect === "function") {
    const top = window.scrollY + target.getBoundingClientRect().top - offs
    window.scrollTo({ top: Math.max(0, top), behavior: "smooth" })
  }
  blinkup(selector)
  drawer.value = false
}

onMounted(() => {
  gettel()

  const subti = () => {
    gsap.set(".subti, .bgdfa, .bgdfb", { opacity: 0 })
    gsap.timeline().to(".subti, .bgdfa, .bgdfb", {
      opacity: 1,
      delay: 1,
      duration: 1.3,
      ease: "sine.out",
    })
  }

  const nagovets = () => {
    gsap.set(".nagovets", { opacity: 0, x: -30 })
    gsap.timeline().to(".nagovets", {
      x: 0,
      opacity: 1,
      delay: 0.4,
      duration: 2.9,
      ease: "expo.out",
    })
  }

  const ludmila = () => {
    gsap.set(".ludmila", { opacity: 0, x: -30 })
    gsap.timeline().to(".ludmila", {
      x: 0,
      opacity: 1,
      delay: 0.2,
      duration: 1.6,
      ease: "expo.out",
    })
  }

  const frontclouds = () => {
    gsap.set(".frontclouds", { opacity: 0.2, x: 70 })
    gsap.timeline().to(".frontclouds", {
      x: 0,
      opacity: 1,
      delay: 0,
      duration: 1.2,
      ease: "power.out",
    })
  }

  gsap.timeline().add(frontclouds()).add(ludmila()).add(nagovets()).add(subti())
})
</script>

<style >
.posred{
 z-index: 9999;
/*right: -20px;*/
  position: absolute;
  opacity: 0.7;
  top: 72px;
}
.whatsapp{
  border-radius: 4px;
  background-image: url('../../images/whatsapp.png');
  background-size: 32px;
  height: 32px;
  width: 32px;
}
.viber{
  border-radius: 4px;
  background-image: url('../../images/viber.png');
  background-size: 32px;
  height: 32px;
  width: 32px;
}
.skype{
  border-radius: 4px;
  background-image: url('../../images/skype.png');
  background-size: 32px;
  height: 32px;
  width: 32px;
}
.telg{
  border-radius: 4px;
  background-image: url('../../images/tg.png');
  background-size: 32px;
  height: 32px;
  width: 32px;
}
.appbar{
  position: relative;
  /*z-index: 5;*/
}
.obraz{
  
}
 
.list6b {
   
  position: relative;

    list-style: none;
}
.list6b li{

    display: inline-block;
    margin:2px;
    padding:0px;
    background-color: rgba(255, 255, 255, 0.8);
}
.list6b li:before {
    
    padding-right:5px;
    font-weight: bold;
    color: #65ba7a;
    content: "\2714";
    transition-duration: 0.5s;
}
.list6b li:hover:before {
    color: #337AB7;
    content: "\2714";
}  
.list6b li{
  padding-left: 8px;
}  
ul.list6b{
  padding-left: 0px !important;
}
.zap_text{
/*background-color: #ada;*/
  position: relative;
  /*z-index: 6;*/
}

.cursor{
  cursor: pointer;
}

.bgdfa, .bgdfb{
  
  /*position: absolute;*/
  /*top: 40px;*/
 
  border-radius: 30% 15%;

/*  left: 70px;
  top: 93px;*/
  /*position: absolute;*/
  height: 26px;
  width: 190px;
  /*background-color: #dad*/
  /*backdrop-filter: blur(2px);*/
  /*background-color: rgb(79.688, 71.652, 47.813, .2);*/
    background-color: rgba(94.629, 156.55, 192.25, 0.4);
}
.bgdfa{
  /*background-color: #dad;*/
margin-left: -187px;
margin-top: 14px;
 
}
.bgdfb{
  /*background-color: #ada;*/
  margin-left: -255px;
  margin-top:  42px;
}
.titleb, .titles{
  /*position: absolute;*/
}
.titleb{ z-index: 5;
  /*width: 700px;*/
  position: absolute;
  margin-top: 60px;
  margin-left: 20px;
}
.titles{

  z-index: 5;
  position: absolute;
  margin-top: 74px;
  margin-left: 10px;
 
    height: 40px;
    width: 589px;

}
.subti{
  align-items: center;
  border-radius: 3px;
  font-family: "Roboto Slab";
  font-weight: 500;
  letter-spacing: 0.3px;
  line-height: 1.2;
  padding: 4px 8px;
  z-index: 1;
}
.titleb .subti{
  width: auto;
    display: inline-flex;
    margin-top: 2px;
    margin-left: 50px;
    text-shadow: rgba(255, 255, 255, 0.25) 0 1px 1px;
  background-color: rgba(86, 91, 99, 0.16);
  color: #1b1d1f;
  font-size: 16px;
  position: absolute;
  white-space: nowrap;
}
.titles .subti{
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.22);
  margin-top: 72px;
  margin-left: 33px;
  text-shadow: rgba(0, 0, 0, 0.14) 0 1px 1px;
  background-color: rgba(255, 255, 255, 0.16);
  color: #fff;
  font-size: 13px;
  font-family: "Roboto Slab";
  font-weight: 500;
  letter-spacing: 0.22px;
  max-width: 320px;
  position: absolute;
}
.subti-phone {
  margin-left: 10px;
}
.subti-phone-link {
  color: #1f2224 !important;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.1px;
}

.titles .subti .subti-phone-link {
  color: #ffffff !important;
  font-size: 12px;
  font-weight: 500;
}

@media (max-width: 599px) {
  .titles .subti {
    margin-left: 22px;
    margin-top: 68px;
    padding: 6px 10px;
    font-size: 12px;
    max-width: 342px;
    background-color: rgba(233, 241, 251, 0.18);
    border-color: rgba(255, 255, 255, 0.36);
    text-shadow: rgba(0, 0, 0, 0.18) 0 1px 1px;
  }
  .titles .subti a {
    font-size: 12px;
  }
  .titleb .subti {
    margin-left: 44px;
    font-size: 15px;
  }
  .subti-phone {
    margin-left: 8px;
  }
}
.titleb .nagovets{
    margin-top: -92px;
    margin-left: 250px;
 
}
.titles .nagovets{
    margin-top: -33px;
    margin-left: -155px;
 
}
.titles .ludmila{
 
 
}
.ludmila{
  z-index: 2;
  position: relative;
  width: 250px;
  height: 87px;
  background-image: url('../../images/ludmila80.png');
}
.nagovets{
  z-index: 2;
  position: relative;
  height: 82px;
  width: 215px;
  background-image: url('../../images/nagovets80.png');
}
.nagb{
/*  margin-left: -30px;
  margin-top: 20px;*/
}
.nags{
  margin-left: 82px;
  margin-top: -120px;
}
.frontclouds{
  width: 100%;   
  height: 121px;
  background-image: url('../../images/frontclouds.png');
  background-position: right;
  position: absolute;
  bottom: 0;
}
.main{
  z-index: 1;
  /*margin-top: -60px;*/
  position: relative;
  border-right-color: #4dd;
}
.headsite{
  overflow: hidden;
  position: relative;
  /*margin-top: -48px;*/
  /*background-color: #dad;*/
  height: 215px;
    background-repeat: repeat-x;
  background-image: url('../../images/head2.jpg');
}
.head1{
  /*float: left;*/
  z-index: 2;
  position: absolute;
  height: 215px;
  width: 201px;
  background-image: url('../../images/head1.jpg');
}
.head2{
    z-index: 1;
    position: relative;
  /*position: absolute;*/
  height: 215px;
}
.head3{
  z-index: 1;
  position: relative;
  margin-left: auto;
  /*margin-right: 0px;*/
  float: right;
  height: 215px;
  width: 915px;
  background-image: url('../../images/head3.jpg');
  background-position: right;
}
.menu{
  border-radius:4px;
  background-color: #fff;
  padding-bottom: 2px;
}
.navigation{
  /*background-color: #dad;*/
}
.mes{
  font-size: 1em;
  text-align: center;
}

.menu-toggle {
  display: none;
}

.desktop-menu {
  display: flex;
}

@media (max-width: 599px) {
  .menu-toggle {
    display: flex !important;
    align-items: center;
  }

  .desktop-menu {
    display: none !important;
  }
}
</style>
