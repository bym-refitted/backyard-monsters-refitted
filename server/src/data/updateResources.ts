import { FieldData } from "../models/save.model";

export interface Resources {
  r1: number;
  r2: number;
  r3: number;
  r4: number;
  r1max?: number;
  r2max?: number;
  r3max?: number;
  r4max?: number;
}

/**
 * Updates the resources with the delta sent from the client.
 * @param {Resources} resources The request body containing the resources.
 * @param {FieldData} saveResources The existing saved resources.
 * @returns Updated resources after applying the delta.
 */
export const updateResources = (resources: Resources, saveResources: FieldData) => {
  if (resources) {
    Object.keys(resources).forEach((key) => {
      const resourceKey = key as keyof Resources;
      if (key.endsWith("max")) {
        saveResources[resourceKey] = resources[key];
      } else {
        saveResources[resourceKey] += resources[key];
      }
    });
  }
  return saveResources;
};
