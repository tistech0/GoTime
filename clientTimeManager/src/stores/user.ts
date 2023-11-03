import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => ({id: 0, username: '', email: '', role: '', time_contract: 0.0}),
  getters: {
      getUser: (state) => state,
      getId: (state) => state.id,
      getUsername: (state) => state.username,
      getEmail: (state) => state.email,
      getRole: (state) => state.role,
      getContractTime: (state) => state.time_contract,
  }
})
