import { defineStore } from 'pinia'

/**
 * This defines the pinia store for the current connected user. Its all the values stored and the getters to get specific ones.
 */
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
