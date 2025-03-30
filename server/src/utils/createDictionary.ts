import { FilterFrontendKeys } from "./FrontendKey";

export const createDictionary = (array, keyName) => {
  return array.reduce((dictionary, item) => {
    const key = item[keyName];
    dictionary[key] = FilterFrontendKeys(item);
    return dictionary;
  }, {});
};