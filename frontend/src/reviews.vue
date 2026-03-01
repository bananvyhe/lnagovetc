<template>
  <div>
  	<v-container class=" py-0 " >
        <v-container class="rev_block py-0 ">
          <div class="aboutTitle headpsy d-flex justify-center pb-3">
            <h2>Отзывы</h2>
          </div>
          <div class="reviews-grid">
            <div class="review-col" v-for="(item, index) in reviews" :key="item.id || index">
              <v-card>
                <div class="px-4 py-3 newsBlock">
                  <div>{{ item.body }}</div>
                  <div class="d-flex justify-end subtitle-2">{{ item.name }}</div>
                </div>

    <div v-admin="isAdmin">
                <div class="my-2">
                    <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                      <template v-slot:activator="{ props }">
                        <v-btn
                          class="ma-2"
                          color="primary"
                          fab
                          x-small
                          dark 
                          @click="getitem(item.id)"
                          v-bind="props">
                         ред
                        </v-btn>
                         <v-btn
                         class="mx-2"
                         x-small
                          color="primary"
                          @click="hidhandle(item.id)"
                        >
                          {{ !hidden && item.id == delitemid  ? 'отмена' : 'удал' }}
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
                      </template>
                   
                      <v-card elevation="2"
                         min-width="344"
                        max-width="874">
                        <v-form>    
                          <v-col
                            cols="12">
                            <v-textarea
                            filled
                              v-model="ebody"
                              label="">
                            </v-textarea>
                          </v-col>
                          <v-col
                            cols="12">
                            <v-text-field
                            filled
                              v-model="ename"
                              label="">
                            </v-text-field>
                          </v-col>  
                            <div class="d-flex justify-end">
                              <v-btn
                                class="ma-2"
                                color="success"
                                @click="datitem(item.id)"
                                small>
                                сохранить
                              </v-btn>
                            </div>                                                  
                        </v-form>
                      </v-card>
                    </v-menu>   
                  </div>
                </div>
              </v-card>
            </div>
          </div>
        </v-container>
   
    <div v-admin="isAdmin">
      <v-card 
        class="ma-2 pa-2"
        max-width="874">
        <h3>Добавить рецензию:</h3>
          <v-form>
            <v-container >
              <v-row>
                <v-col
                  cols="12"
                  md="6">
                  <v-textarea
                    min-width="544"
                    v-model="abody"
                    filled
                    label="отзыв"
                    required
                  ></v-textarea>
                </v-col>

                <v-col
                  cols="12"
                  md="6">
                  <v-text-field
                    v-model="aname"
                    label="имя"
                    required
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
        </v-card>

    </div>          
  	</v-container>
  </div>
</template>

<script setup>
import { getCurrentInstance, onMounted, ref } from "vue"
import { useAdmin } from "./composables/useAdmin"
import { useRequestRetry } from "./composables/useRequestRetry"

const { proxy } = getCurrentInstance()
const { isAdmin } = useAdmin()
const { requestWithRetry } = useRequestRetry()

const abody = ref("")
const aname = ref("")
const delitemid = ref("")
const hidden = ref(true)
const ename = ref("")
const ebody = ref("")
const closeOnContentClick = ref(false)
const reviews = ref([])


const loadReviews = async () => {
  try {
    const response = await requestWithRetry(() => proxy.$http.plain.get("/reviews"))
    reviews.value = Array.isArray(response.data) ? response.data : []
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const aitem = async () => {
  try {
    await proxy.$http.secured.post("/arevitem", { name: aname.value, body: abody.value })
    await loadReviews()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const showdel = (dat) => hidden.value == false && delitemid.value == dat

const hidhandle = (dat) => {
  delitemid.value = dat
  hidden.value = !hidden.value
}

const delitem = async (dat) => {
  try {
    await proxy.$http.secured.delete("/delrevitem/" + dat)
    await loadReviews()
    hidden.value = true
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const datitem = async (dat) => {
  try {
    await proxy.$http.secured.post("/saverevitem", {
      id: dat,
      name: ename.value,
      body: ebody.value,
    })
    await loadReviews()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const getitem = async (dat) => {
  try {
    const response = await proxy.$http.plain.post("/getrev", { id: dat })
    ebody.value = response.data.body
    ename.value = response.data.name
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

onMounted(loadReviews)
</script>

<style >
.reviews-grid {
  column-count: 2;
  column-gap: 16px;
}

.review-col {
  break-inside: avoid;
  margin-bottom: 16px;
}

@media (max-width: 960px) {
  .reviews-grid {
    column-count: 1;
  }
}
</style>
