import z from "zod";
import { FieldData } from "../../models/save.model";

export interface Resources {
  r1?: number;
  r2?: number;
  r3?: number;
  r4?: number;
  r1max?: number;
  r2max?: number;
  r3max?: number;
  r4max?: number;
}

export enum Operation {
  ADD = "add",
  SUBTRACT = "subtract",
}

/**
 * Updates the resources with the delta sent from the client.
 * 
 * @param {Resources} resources - The request body containing the resources.
 * @param {FieldData} saveResources - The existing saved resources.
 * @param {Operation} [operation = Resource.ADD] - The type of operation to perform (add or subtract).
 * @returns {FieldData} Updated resources after applying the delta.
 */
export const updateResources = (
  resources: Resources,
  saveResources: FieldData,
  operation: Operation = Operation.ADD
) => {
  if (resources) {
    Object.keys(resources).forEach((key) => {
      const resourceKey = key as keyof Resources;
      if (key.endsWith("max")) {
        saveResources[resourceKey] = resources[key];
      } else {
        saveResources[resourceKey] +=
          operation === Operation.ADD ? resources[key] : -resources[key];
      }
    });
  }
  return saveResources;
};
