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