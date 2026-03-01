<template>
  <div>
    <v-container class=" py-2 " >
      <v-row >
        <v-col class=" d-flex flex-column py-1" cols="12"  sm="12" md="6" lg="7" >
          <div class="about "> 
            <div class="bg_books"></div>
            <div class="books"></div>
            <div class="about_block my-0 px-0" >
              <div>
                <div  id='about_block' class="aboutTitle " v-bind:class="{ ikses: isCompactLayout }" > 
                  <h2 >Обо мне </h2>
                </div>
                <img
                  class="foto"
                  :src="fotoSrc"
                  alt="Людмила Наговец, психолог-психоаналитик"
                  width="227"
                  height="275"
                  loading="eager"
                  decoding="async"
                  fetchpriority="high"
                />
                <span style >
                {{about}}
                </span> 
              </div>
            </div>              
          </div>

          <div class="posred" v-admin="isAdmin">
            <v-menu offset-y
              :close-on-content-click="closeOnContentClick">
              <template v-slot:activator="{ props }">
                <v-btn
                  class="ma-2"
                  color="primary"
                  fab
                  x-small
                  dark 
                  @click="getred()"
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
                      v-model="about"
                      label="">
                    </v-textarea>
                  </v-col>

                  <div class="d-flex justify-end">
                    <v-btn
                      class="ma-2"
                      color="success"
                      @click="reditem()"
                      small>
                      сохранить
                    </v-btn>
                  </div>                                                  
                </v-form>
              </v-card>                    
            </v-menu>
          </div>

          <div class="konsultBlock mb-3 mt-2 px-2">
            <h2>Как проходит консультация?</h2>
            <span >{{consult}}</span>

            <div class="posred" v-admin="isAdmin">
              <v-menu offset-y
                :close-on-content-click="closeOnContentClick">
                <template v-slot:activator="{ props }">
                  <v-btn
                    class="ma-2"
                    color="primary"
                    fab
                    x-small
                    dark 
                    @click="getred()"
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
                        v-model="consult"
                        label="">
                      </v-textarea>
                    </v-col>

                    <div class="d-flex justify-end">
                      <v-btn
                        class="ma-2"
                        color="success"
                        @click="reditem()"
                        small>
                        сохранить
                      </v-btn>
                    </div>                                                  
                  </v-form>
                </v-card>                    
              </v-menu>
            </div>

            </div>
            <div class="zaprosBlock ">
              <div class="psyholog_bg"></div>
              <div class="psyholog"></div>
              <v-container>
                <div class="headpsy aboutTitle">
                  <h2>С какими запросами я работаю?</h2>
                  Я могу Вам помочь:
                </div>
                <div >
                   <!-- {{req}} -->
                <ul class="list6b pt-1"
                  v-for="item in req"
                  :key="item.name"> 
                  <li>
                    {{item.position}}
<div class="pt-2" v-admin="isAdmin">
                    <v-btn
                    class="mx-2"
                    x-small
                    color="primary"
                    @click="hidhandle(item.id)">
                      {{!hidden && item.id == delitemid  ? 'отмена' : 'удал'}}
                    </v-btn>
                    <v-btn
                    absolute
                    right
                    v-show="showdel(item.id)"
                    class="mx-2"
                    color="red"
                    fab
                    x-small
                    dark 
                    @click="delitem(item.id)">
                      удал
                    </v-btn>
</div>
                  </li>
                </ul>

                <div class="pt-2" v-admin="isAdmin">
                  <h3>Добавить:</h3>

                  <v-form>
                    <v-container class="pt-0">
                      <v-row>
                        <v-col
                          cols="12"
                          md="6">
                          <v-text-field
                            v-model="position"
                            label="запрос"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <div class="d-flex justify-end">
                        <v-btn
                        color="success"
                        @click="aitem()"
                        small>
                        добавить
                      </v-btn>
                      </div>
                    </v-container>
	                  </v-form>    
	                </div>

	              </div>
	            </v-container>
          </div>
        </v-col>
            
        <v-col class="know_block d-flex py-0" cols="12"    sm="12" md="6" lg="5" >
          <div class="d-flex align-stretch obraz">
            <div>
              <div class="headpsy aboutTitle d-flex justify-center">
                <h2>Образование</h2>  
              </div>

	              <div v-for="(item, index) in filteredListtrue"  > 
	                <div class="py-1 px-4">
	                  {{index+1+"."}}   {{item.desc}}
	                </div>
	              </div>  

              <div>
               Прошла дополнительное обучение по профессиональным программам: 
              </div>
              <div v-for="(item, index) in filteredListfalse" class=" pl-6"> 
                <ul>
                  <li>
                    {{item.desc}}

<div class="pt-2" v-admin="isAdmin">
                    <v-btn
                    class="mx-2"
                    x-small
                    color="primary"
                    @click="hidhandleed(item.id)">
                      {{!hidden && item.id == delitemid  ? 'отмена' : 'удал'}}
                    </v-btn>
                    <v-btn
                    absolute
                    right
                    v-show="showdeled(item.id)"
                    class="mx-2"
                    color="red"
                    fab
                    x-small
                    dark 
                    @click="delitemed(item.id)">
                      удал
                    </v-btn>
</div>



                  </li>
                </ul>
              </div> 

                <div class="pt-2" v-admin="isAdmin">
                  <h3>Добавить:</h3>

                  <v-form>
                    <v-container class="pt-0">
                      <v-row>
                        <v-col
                          cols="12"
                          md="6">
                          <v-text-field
                            v-model="positioned"
                            label="добавить программу"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <div class="d-flex justify-end">
                        <v-btn
                        color="success"
                        @click="aitemed()"
                        small>
                        добавить 
                      </v-btn>
                      </div>
                    </v-container>
                  </v-form>    
                </div>


            </div>
          </div>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script setup>
import { computed, getCurrentInstance, onMounted, ref } from "vue"
import { useAdmin } from "./composables/useAdmin"
import { useRequestRetry } from "./composables/useRequestRetry"
import gsap from "gsap"
import fotoSrc from "./images/foto10.png"

const { proxy } = getCurrentInstance()
const { isAdmin } = useAdmin()
const { requestWithRetry } = useRequestRetry()

const hiddened = ref(true)
const delitemided = ref("")
const delitemid = ref("")
const positioned = ref("")
const ed = ref([])
const hidden = ref(true)
const position = ref("")
const req = ref([])
const closeOnContentClick = ref(false)
const consult = ref("")
const about = ref("")

const isCompactLayout = computed(() => {
  const vuetifyObj = proxy?.$vuetify || {}
  const display = vuetifyObj.display || {}
  const breakpoint = vuetifyObj.breakpoint || {}
  return Boolean(display.md || display.xs || breakpoint.md || breakpoint.xs)
})
const filteredListtrue = computed(() => ed.value.filter((it) => it.main == true))
const filteredListfalse = computed(() => ed.value.filter((it) => it.main == false))

const hidhandleed = (dat) => {
  delitemided.value = dat
  hiddened.value = !hiddened.value
}

const geted = async () => {
  try {
    const response = await requestWithRetry(() => proxy.$http.plain.get("/educations"))
    ed.value = Array.isArray(response.data) ? response.data : []
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const delitemed = async (dat) => {
  try {
    await proxy.$http.secured.delete("/delitemed/" + dat)
    await geted()
    hiddened.value = true
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const showdeled = (dat) => hiddened.value == false && delitemided.value == dat

const aitemed = async () => {
  try {
    await proxy.$http.secured.post("/aitemed", { desc: positioned.value, main: false })
    await geted()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const showdel = (dat) => hidden.value == false && delitemid.value == dat

const hidhandle = (dat) => {
  delitemid.value = dat
  hidden.value = !hidden.value
}

const getreq = async () => {
  try {
    const response = await requestWithRetry(() => proxy.$http.plain.get("/requests"))
    req.value = Array.isArray(response.data) ? response.data : []
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const delitem = async (dat) => {
  try {
    await proxy.$http.secured.delete("/delitemreq/" + dat)
    await getreq()
    hidden.value = true
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const aitem = async () => {
  try {
    await proxy.$http.secured.post("/aitemzap", { position: position.value })
    await getreq()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const getred = async () => {
  try {
    const response = await requestWithRetry(() => proxy.$http.plain.get("/redactors"))
    const payload = response?.data || {}
    about.value = payload.about || ""
    consult.value = payload.consult || ""
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const reditem = async () => {
  try {
    await proxy.$http.secured.post("/saveredtitem", { id: 1, about: about.value, consult: consult.value })
    await proxy.$http.plain.get("/redactors")
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

onMounted(async () => {
  await Promise.all([getred(), getreq(), geted()])
  gsap.set(".foto", { opacity: 0 })
  gsap.timeline().to(".foto", {
    opacity: 1,
    duration: 1.9,
    delay: 0.8,
    ease: "expo.out",
  })
})
</script>

<style >
.posred{
  z-index: 9999;
  position: absolute;
}
.li{
  display: flex;
    justify-content: space-around;
}
.map{
  width: 100%;
}
.priceHead{
  background-color: #edf0eac9;
}
.newsBlock{
  /*background-color: rgba(239.13, 255, 223, 0.4);*/
  background-color: rgba(233.08, 247, 231, 0.3);
  border-radius: 4px;
}
.menbg{
  border-radius: 4px;
  background-color: #fff;
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
    margin:0px;
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
.psyholog_bg{ 
 border-radius: 10px 10px;
  /*top: 0;*/
  position: absolute;
  background-image: url('./images/psy_bg.jpg');
  background-repeat: repeat-x;
  width: 100%;
  height: 351px;
}
.psyholog{
 border-radius: 10px 10px;
  height: 351px;
  position: absolute;
  width: 100%;
  background-position: right;
  background-image: url('./images/psy.jpg');
  background-size: 470px;
}
.zaprosBlock{
  min-height: 280px;
}
.konsultBlock, .zaprosBlock, .about_block{
  /*background-color: #dad;*/
  position: relative;
  /*padding-left: 1em;*/


}
.konsultBlock h2, .zaprosBlock h2{
  color: #43a4dc;
  /*padding-left: 1em;*/
}
.education{
 
 border-radius: 12px;
 /*border-top: 32px solid  #43a4dc;*/


}
.education h2{
    /*margin-top: -2em*/
  color: #43a4dc;
    /*text-align: center;*/
  /*background-color: #43a4dc;*/
}
.aboutTitle{ position: relative;
  /*background-color: #dad;*/
  margin-left: -12px;
  padding-left: 12px;
  color: #43a4dc;
  /*display: flex;*/
  /*align-self: center;*/
}

 

.fotoframe{
 
  position: relative;
 
}
/*.blankfoto{
  width: 50px;
}*/
/*.textabout{
  z-index: 5000;

}*/
.textabout span {

  display: inline;
  /*box-shadow: -10px 0 0 rgba(0, 0, 0, 0.5), 10px 0 0 rgba(0, 0, 0, 0.5);*/
  background-color: rgba(255, 255, 255, 0.7);
}
.relative{
  position: relative;
}
.books_bg{
/*  position: absolute;
  top: 0;
  width: 100%;
  height: 239px;
  background-image: url('./images/bg_books.jpg');
    background-repeat: repeat-x;
  border-radius: 25px 10px;*/
}
.books{  
  border-radius: 25px 10px;
  position: absolute;
  /*z-index: 1;*/
  width: 100%;
  height: 239px;
  background-position: right;
  background-image: url('./images/books.jpg');
  /*background-color: #dad;*/
}
 
.abcont{
  position: relative;
  /*background-color: #dad;*/
}
.bg_books{
 
  position: absolute;
   height: 239px;
   width: 100%;
   background-image: url('./images/bg_books.jpg');
  background-repeat: repeat-x;
  border-radius: 25px 10px;
}
.ikses {
    white-space: nowrap;
    color: #fff !important;
    background-color: rgb(179.688, 171.652, 147.813, .3);
}
.ikses h2{
 text-shadow: 1px 1px rgb(0, 0, 0, .6);
  }
.foto{

  position: relative;
  border-radius: 25px 10px;
/*  right: 0;
  bottom: 0;*/
  /*position: absolute;*/
  z-index: 4;
  float: right;
  margin-top: -65px;
  margin-left: -50px;
  width: 227px;
  height: 275px;
  object-fit: cover;
  object-position: center;
  /*background-color: #dad;*/
}
.about{ 
  /*background-color: #dad;*/
    /*display: table-cell;*/
  /*vertical-align: bottom;*/
  /*flex-direction: column;*/
  position: relative;
  /*z-index: 3;*/
  /*min-height: 239px; */
 border-radius: 25px 10px;
  /*background-repeat: repeat-x;*/
}

.about span{
 
  /*display: inline;*/

  background-color: rgba(255, 255, 255, 0.9);
  /*box-shadow: -10px 0 0 rgba(255, 255, 255, 0.8), 10px 0 0 rgba(255, 255, 255, 0.8);*/
}
.aboutBlock{
  float: left;
  /*background-image: radial-gradient(circle farthest-corner at top right, #49cff5, #fff);*/
}
.cursor{
  cursor: pointer;
}


.main{
  z-index: 1;
  /*margin-top: -60px;*/
  position: relative;
  border-right-color: #4dd;
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
</style>
