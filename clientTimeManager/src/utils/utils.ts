import type { Item } from "../types/items";


/**
 * This function allows to take in an array of objects and transform it into an array of Items.
 * We need the equivalent of the id and name attribute in order to be able to pass in the data structure that we want.
 * 
 * @param data is an array of Objects
 * @param idAttr is the id attribute of the object passed in the array
 * @param nameAttr is the name attribute of the object passed in the array
 * @returns a list of items
 */
export function transformData(data: any[], idAttr: string, nameAttr: string): Item[] {
    return data.map((item) => ({
      id: item[idAttr],
      name: item[nameAttr],
    }));
}


/**
 * This function handles generically errors returned from the api.
 * 
 * @param response is the HttpResponse object fetch from the api
 * @param snackbarStore is the snackbarStore from pinia of type <Store ...>
 * @param router is the router from vue of type 'Router'
 */
export async function errorHandling(response: Response, snackbarStore: any, router: any) {
  if (response.status == 500) {
    snackbarStore.showSnackbar('An error occurred. Please contact an administrator.', 2000, 'error');
    return
  }
  const error = await response.json();
  snackbarStore.showSnackbar(error.error, 2000, 'error');
  if (response.status == 401) {
    router.push({name : 'login'})
  } else if(response.status == 403) {
    router.push({name : 'home'})
  }
}