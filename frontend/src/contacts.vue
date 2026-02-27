<template>
  <div>
     <v-container class="contact_block pt-0">
          <div class="aboutTitle d-flex justify-center pb-4">
            <h2>Контакты</h2> 
          </div>
              <div class="d-flex flex-column justify-center align-center pb-4"> 

                <h4>Консультирую:</h4>
                  <div class="body-1 my-2 mb-1">
                    <span v-html="contacts[0]?.desc || ''"></span>
                    <div class="desc" v-admin="isAdmin">
                      <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                        <template v-slot:activator="{ props }">
                      <v-btn
                        class="ma-2"
                        color="primary"
                        fab
                        x-small
                        dark 
                        @click="getcont(0)"
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
                              v-model="econt"
                              label="">
                            </v-textarea>
                          </v-col>

                            <div class="d-flex justify-end">
                              <v-btn
                                class="ma-2"
                                color="success"
                                @click="contitem(1)"
                                small>
                                сохранить
                              </v-btn>
                            </div>                                                  
                        </v-form>
                      </v-card>                    
                  </v-menu>
                    </div>              
                  </div> 
                  <div class="body-1 mt-0 mb-3">
                    <span v-html="contacts[1]?.desc || ''"></span>
                    <div class="desc" v-admin="isAdmin">
                      <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                        <template v-slot:activator="{ props }">
                          <v-btn
                            class="ma-2"
                            color="primary"
                            fab
                            x-small
                            dark 
                            @click="getcont(1)"
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
                                v-model="econt"
                                label="">
                              </v-textarea>
                            </v-col>

                              <div class="d-flex justify-end">
                                <v-btn
                                  class="ma-2"
                                  color="success"
                                  @click="contitem(2)"
                                  small>
                                  сохранить
                                </v-btn>
                              </div>                                                  
                          </v-form>
                        </v-card>                    
                      </v-menu>
                    </div>                                  
                  </div> 
                  <div class="body-1 mt-0 mb-3">
                      <span v-html="contacts[2]?.desc || ''"></span>
                    <div class="desc" v-admin="isAdmin">
                      <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                        <template v-slot:activator="{ props }">
                          <v-btn
                            class="ma-2"
                            color="primary"
                            fab
                            x-small
                            dark 
                            @click="getcont(2)"
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
                                v-model="econt"
                                label="">
                              </v-textarea>
                            </v-col>

                              <div class="d-flex justify-end">
                                <v-btn
                                  class="ma-2"
                                  color="success"
                                  @click="contitem(3)"
                                  small>
                                  сохранить
                                </v-btn>
                              </div>                                                  
                          </v-form>
                        </v-card>                    
                      </v-menu>
                    </div>    

                  </div> 
<!--                 <div class="body-1 my-2 mb-1">ОНЛАЙН - по видеосвязи (мессенджеры: Scype, WhatsApp, Viber, Telegram)
                </div>
                <div class="body-1 mt-0 mb-3">ОЧНО - в Екатеринбурге по адресу: Тверитина 34, корпус 5.</div> -->
 <!-- 
                <v-expansion-panels>
    <v-expansion-panel>
        <v-expansion-panel-header disable-icon-rotate>
          Открыть карту
          <template v-slot:actions>
            <v-icon color="teal">
              mdi-check
            </v-icon>
          </template>
        </v-expansion-panel-header>
        <v-expansion-panel-content> -->
          <div class="address-map-wrap" v-if="addressText && mapEmbedHtml">
            <span class="address-trigger">{{ addressText }}</span>
            <div class="address-map-popover" v-html="mapEmbedHtml"></div>
          </div>
<v-container > 
                    <div class=" " v-admin="isAdmin">редактор карты:
                      <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                        <template v-slot:activator="{ props }">
                      <v-btn
                        class="ma-2"
                        color="primary"
                        fab
                        x-small
                        dark 
                        @click="getcont(5)"
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
                              v-model="econt"
                              label="">
                            </v-textarea>
                          </v-col>

                            <div class="d-flex justify-end">
                              <v-btn
                                class="ma-2"
                                color="success"
                                @click="contitempos(1)"
                                small>
                                сохранить
                              </v-btn>
                            </div>                                                  
                        </v-form>
                      </v-card>                    
                  </v-menu>
                    </div>      

</v-container>

<!--  
                  <a href="https://yandex.ru/maps/54/yekaterinburg/?utm_medium=mapframe&utm_source=maps" style="color:#eee;font-size:12px;position:absolute;top:0px;">Екатеринбург</a>
                  <a href="https://yandex.ru/maps/54/yekaterinburg/house/ulitsa_tveritina_34_5/YkkYcAVlQEYEQFtsfXRzc3lgbA==/?ll=60.625933%2C56.822538&source=wizgeo&utm_medium=mapframe&utm_source=maps&z=17" style="color:#eee;font-size:12px;position:absolute;top:14px;">Улица Тверитина, 34/5 — Яндекс Карты</a>
                  <iframe  src="https://yandex.ru/map-widget/v1/-/CCUB6JWA9A"  height="600" frameborder="1" allowfullscreen="true" style="position:relative;width:100%;"></iframe>
                </div> -->

     <!--    </v-expansion-panel-content>
      </v-expansion-panel> </v-expansion-panels>
 -->
          <div class="mt-4">
          разработка сайта: <a href="https://pixeltech.ru">pixeltech.ru</a> 
          </div>
                </div> 
              
        </v-container> 
  </div>
</template>

<script setup>
import { computed, getCurrentInstance, onMounted, ref } from "vue"
import { useAdmin } from "./composables/useAdmin"

const { proxy } = getCurrentInstance()
const { isAdmin } = useAdmin()

const closeOnContentClick = ref(false)
const contacts = ref([
  { desc: "", position: "", tel: "" },
  { desc: "", position: "", tel: "" },
  { desc: "", position: "", tel: "" },
])
const econt = ref("")

const getcont = async (dat) => {
  try {
    const response = await proxy.$http.plain.get("/contacts")
    contacts.value = Array.isArray(response.data) ? response.data : []

    if (dat === undefined || dat === null) {
      econt.value = ""
      return
    }

    if (dat == 5) econt.value = contacts.value[0]?.position || ""
    else econt.value = contacts.value[dat]?.desc || ""
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const contitempos = async (dat) => {
  try {
    await proxy.$http.secured.post("/savecontitem", { id: dat, position: econt.value })
    await getcont()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const contitem = async (dat) => {
  try {
    await proxy.$http.secured.post("/savecontitem", { id: dat, desc: econt.value })
    await getcont()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const mapEmbedHtml = computed(() => {
  const fromDb = contacts.value[0]?.position || ""
  if (fromDb && fromDb.trim().length > 0) return fromDb
  return `<iframe src="https://yandex.ru/map-widget/v1/-/CCUB6JWA9A" height="420" frameborder="0" allowfullscreen="true" style="position:relative;width:100%;"></iframe>`
})

const addressText = computed(() => {
  const raw = contacts.value[1]?.desc || contacts.value[0]?.desc || ""
  const plain = raw.replace(/<[^>]*>/g, " ")
  const match = plain.match(/(Тверитина[^.,\n]*(?:,\s*\d+\/?\d*)?(?:,\s*корпус\s*\d+)*)/i)
  const parsed = (match && match[1] ? match[1] : "").trim()
  return parsed || "Екатеринбург, ул. Тверитина, 34/5"
})

onMounted(() => {
  getcont()
})
</script>

<style >
  .body-1{
    position: relative;  
  }
 .desc{
  opacity: 0.7;
  z-index: 10;
  position: absolute;
  top: -18px;
  left: -20px;
  /*padding-top: -30px;*/
  max-width: 880px;
 }

 .body-1 a {
  text-decoration: underline;
 }

 .body-1 iframe {
  max-width: 100%;
 }

 .address-map-wrap {
  margin: 12px 0 8px;
  position: relative;
  text-align: center;
  width: 100%;
  padding-bottom: 10px;
 }

 .address-trigger {
  border-bottom: 1px dashed #555;
  color: #1a1a1a;
  cursor: pointer;
  display: inline-block;
  font-weight: 500;
 }

 .address-map-popover {
  background: #fff;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.22);
  left: 50%;
  opacity: 0;
  pointer-events: none;
  position: absolute;
  top: calc(100% - 6px);
  transform: translate(-50%, -4px);
  transition: opacity 0.2s ease, transform 0.2s ease;
  width: min(100%, 740px);
  z-index: 20;
 }

 .address-map-wrap:hover .address-map-popover,
 .address-map-wrap:focus-within .address-map-popover {
  opacity: 1;
  pointer-events: auto;
  transform: translate(-50%, 0);
 }

 .address-map-popover iframe {
  border: 0;
  display: block;
  width: 100%;
 }

 @media (max-width: 800px) {
  .address-map-popover {
    position: static;
    opacity: 1;
    pointer-events: auto;
    transform: none;
    width: 100%;
  }
 }
</style>
