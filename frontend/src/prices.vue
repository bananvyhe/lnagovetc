<template>
  <div>
        <v-container class="price_block pt-0">
          <div class="headpsy aboutTitle d-flex justify-center pb-1 ">
            <h2>Стоимость</h2>
          </div>
        <v-simple-table dense>
          <template >
            <thead>
              <tr>
                <th class="text-left priceHead">
                  <h3>Наименование услуги:</h3>
                </th>
                <th class="text-left priceHead">
                  <h3></h3>
                </th>
                <th class="text-left priceHead">
                  <h3>Длительность:</h3>
                </th>
                <td class="text-left priceHead" v-admin="isAdmin">
                  редактировать:
                </td>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="item in prices"
                :key="item.name"> 
                <td>{{ item.name }}</td>
                <td>{{ item.cost }}&nbsp;руб.</td>
                <td>{{ item.duration }}</td>
                <td v-admin="isAdmin">
                  <div class="my-2">
                    <v-menu offset-y
                      :close-on-content-click="closeOnContentClick">
                      <template v-slot:activator="{ props }">
                        <v-btn
                          color="primary"
                          fab
                          x-small
                          dark 
                          @click="getitem(item.id)"
                          v-bind="props"
                           >
                         ред
                        </v-btn>
                        <!-- {{item.id}} -->
                         <v-btn
                         class="mx-2"
                         x-small
                          color="primary"
                          @click="hidhandle(item.id)"
                        >
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

                      </template>
                   
                      <v-card elevation="2"
                        class="px-2 py-2"
                         min-width="244"
                        max-width="874">
                            <v-form>
                              <v-container >
                                <v-row>
                                  <v-col
                                    cols="12"
                                    md="4"
                                  >
                                    <v-text-field
                                      v-model="gname"
                                      label="наименование услуги"
                                      required
                                    ></v-text-field>
                                  </v-col>

                                  <v-col
                                    cols="12"
                                    md="4"
                                  >
                                    <v-text-field
                                      v-model="gcost"
                                      label="цена"
                                      required
                                    ></v-text-field>
                                  </v-col>

                                  <v-col
                                    cols="12"
                                    md="4"
                                  >
                                    <v-text-field
                                      v-model="gduration"
                                      label="длительность"  
                                    ></v-text-field>
                                  </v-col>
                                </v-row>
                                <div class="d-flex justify-end">
                                  <v-btn
                                  color="success"
                                  @click="datitem(item.id)"
                                  small>
                                  сохранить
                                </v-btn>
                                </div>
                              </v-container>

                            </v-form>    
                      </v-card>
                    </v-menu>   
                  </div>
                </td>
              </tr>
              &nbsp; 
 
            </tbody>
          </template>
        </v-simple-table>
        <div v-admin="isAdmin">
          <h3>Добавить услугу:</h3>

             <v-form>
                <v-container >
                  <v-row>
                    <v-col
                      cols="12"
                      md="4"
                    >
                      <v-text-field
                        v-model="aname"
     
     
                        label="наименование услуги"
                        required
                      ></v-text-field>
                    </v-col>

                    <v-col
                      cols="12"
                      md="4"
                    >
                      <v-text-field
                        v-model="acost"
     
                        label="цена"
                        required
                      ></v-text-field>
                    </v-col>

                    <v-col
                      cols="12"
                      md="4"
                    >
                      <v-text-field
                        v-model="aduration"
     
                        label="длительность"
                         
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

        </v-container>
  </div>
</template>

<script setup>
import { getCurrentInstance, onMounted, ref } from "vue"
import { useAdmin } from "./composables/useAdmin"

const { proxy } = getCurrentInstance()
const { isAdmin } = useAdmin()

const delitemid = ref("")
const hidden = ref(true)
const aduration = ref("")
const acost = ref("")
const aname = ref("")
const gduration = ref("")
const gcost = ref("")
const gname = ref("")
const closeOnContentClick = ref(false)
const prices = ref([])

const loadPrices = async () => {
  try {
    const response = await proxy.$http.plain.get("/prices")
    prices.value = response.data
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
    await proxy.$http.secured.delete("/delitem/" + dat)
    await loadPrices()
    hidden.value = true
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const aitem = async () => {
  try {
    await proxy.$http.secured.post("/aitem", {
      name: aname.value,
      cost: acost.value,
      duration: aduration.value,
    })
    await loadPrices()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const getitem = async (dat) => {
  try {
    const response = await proxy.$http.secured.post("/getitem", { id: dat })
    gname.value = response.data.name
    gcost.value = response.data.cost
    gduration.value = response.data.duration
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

const datitem = async (dat) => {
  try {
    await proxy.$http.secured.post("/saveitem", {
      id: dat,
      name: gname.value,
      cost: gcost.value,
      duration: gduration.value,
    })
    await loadPrices()
  } catch (error) {
    proxy.setError?.(error, "Something went wrong")
  }
}

onMounted(loadPrices)
</script>

<style >
 
</style>
