import { defineStore } from 'pinia';

/**
 * This store is used to trigger a snackbar. This has to be setup at the page level so that it limits code duplication.
 */
export const useSnackbarStore = defineStore({
  id: 'snackbar',
  state: () => ({
    isOpen: false,
    message: '',
    color: ''
  }),
  actions: {
    /**
     *  This function allows to display the snackbar and to customize it.
     * 
     * @param message is the message to display 
     * @param duration is the duration of the snackbar
     * @param color is the color of the snackbar. It takes the value "error" or "success". By default, it will be success.
     */
    showSnackbar(message: string, duration: number, color: string = 'success') {
      this.isOpen = true;
      this.message = message;
      this.color = color;
      setTimeout(this.hideSnackbar, duration);
    },
    /**
     * This function hides the snackbar and resets the values
     */
    hideSnackbar() {
      this.isOpen = false;
      this.message = '';
    },
  },
});