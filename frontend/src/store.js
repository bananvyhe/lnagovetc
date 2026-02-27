import { defineStore } from "pinia";

export const useLogStore = defineStore("logStore", {
  state: () => ({
    ctsrf: null, 
    signedIn: false,
    currentUser: {},

  }),
  getters: {
    thiscurrentUser(){
      return this.currentUser
    },    
    thiscsrf(){
      return this.ctsrf
    },   
    thissignedIn(){
      return this.signedIn
    },

  },
  actions: {
    setCurrentUser (currentUser, csrf) {
      this.currentUser = currentUser
      this.signedIn = true
      this.ctsrf = csrf
    },
    unsetCurrentUser () {
      this.currentUser = {}
      this.signedIn = false
      this.ctsrf = null
    },
    refresh (csrf) {
      this.signedIn = true
      this.ctsrf = csrf
    },    
 
  }, 
  persist: true,
})
 