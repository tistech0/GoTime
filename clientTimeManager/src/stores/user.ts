import { defineStore } from 'pinia'
import type { User } from '../types/user'
import { Role } from '@/constants/RoleEnum'


/**
 * This defines the pinia store for the current connected user.
 * The data are persisted in the local sotrage
 */
export const useUserStore = defineStore({
  id: 'user',
  state: () => ({
    user: null as User | null,
    isAuthenticated: false
    }),
  getters: {
      getUser: (state) => state.user,
      getIsAuthenticated: (state) => state.isAuthenticated
  },
  actions: {
    /**
     * This function sets in the userStore all the values needed on the current_user
     * It also sets the user as connected.
     * The state is persisted through the app because we set it to the localstorage
     * 
     * @param currentUser is the user returned on login
     */
    loginUser(currentUser: User) {
      // set the current user role with the right enum value.
      currentUser.role = Role[currentUser.role as keyof typeof Role] || currentUser.role

      // Log the user by persisting the values.
      this.user = currentUser;
      this.isAuthenticated = true;
    },

    /**
     * This function sets all the values concerning the user back to its original state
     * We remove it from the local storage.
     */
    logoutUser() {
      this.user = null;
      this.isAuthenticated = false;
    }
  },
  persist: true,
})
