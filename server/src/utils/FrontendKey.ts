import "reflect-metadata";

const FrontendKeyMetadataKey = Symbol("FrontendKey");

/**
 * A TypeScript decorator that marks a property to be included in the frontend.
 *
 * @param {Object} target - The target object.
 * @param {string} propertyKey - The name of the property to mark.
 */
export const FrontendKey = (target: any, propertyKey: string) => {
  Reflect.defineMetadata(FrontendKeyMetadataKey, true, target, propertyKey);
};

/**
 * Filters the properties of an instance to include only those marked with the FrontendKey decorator.
 *
 * @template T
 * @param {T} instance - The instance to filter.
 * @returns {Partial<T>} A new object containing only the properties marked with the FrontendKey decorator.
 */
export const FilterFrontendKeys = <T extends object>(instance: T): Partial<T> =>
  Object.fromEntries(
    Object.entries(instance).filter(([key]) => Reflect.getMetadata(FrontendKeyMetadataKey, instance, key))
  ) as Partial<T>;
