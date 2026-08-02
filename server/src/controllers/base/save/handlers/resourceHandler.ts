import {
  type Resources,
  updateResources,
} from "../../../../services/base/updateResources.js";
import { Save } from "../../../../models/save.model.js";
import { SaveKeys } from "../../../../enums/SaveKeys.js";

/**
 * Options controlling where a delta lands and how much of it is applied.
 */
interface ResourceOptions {
  key?: SaveKeys.RESOURCES | SaveKeys.IRESOURCES;

  /**
   * Drop the `rNmax` fields. Set when the delta came from an outpost session: the client
   * computes capacity from the buildings in the yard it currently has loaded, so an
   * outpost's caps are not the main yard's caps.
   */
  skipCapacity?: boolean;
}

type ResourceDelta = Resources | string | undefined;

/**
 * Applies a client resource delta to a save.
 *
 * @param {Save} save - The save to write to
 * @param {ResourceDelta} resourceDelta - The delta, stringified or not
 * @param {ResourceOptions} [options = {}] - Pool selection and capacity handling
 */
export const resourcesHandler = (save: Save, resourceDelta: ResourceDelta, options: ResourceOptions = {}) => {
  const { key = SaveKeys.RESOURCES, skipCapacity = false } = options;

  let resourceData: Resources | null = null;

  if (resourceDelta) {
    try {
      resourceData = JSON.parse(resourceDelta as string);
    } catch {
      resourceData = resourceDelta as Resources;
    }
  }

  if (resourceData) {
    if (skipCapacity) {
      const { r1max, r2max, r3max, r4max, ...amounts } = resourceData;
      resourceData = amounts;
    }

    save[key] = updateResources(resourceData, save[key] ?? {});
  }
};
