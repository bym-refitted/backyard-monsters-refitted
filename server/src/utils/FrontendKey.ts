const frontendKeysByProto = new WeakMap<object, Set<string | symbol>>();

/**
 * A decorator that marks a property to be included in the frontend response.
 * Works with ES stage 3 decorators (no reflect-metadata required).
 *
 * @param _value - Unused (class field decorators receive undefined)
 * @param context - The decorator context containing the property name
 */
export const FrontendKey = (_: undefined, context: ClassFieldDecoratorContext): void => {
  context.addInitializer(function(this: unknown) {
    const proto = Object.getPrototypeOf(this as object);
    let keys = frontendKeysByProto.get(proto);
    if (!keys) {
      keys = new Set<string | symbol>();
      frontendKeysByProto.set(proto, keys);
    }
    keys.add(context.name);
  });
};

/**
 * Filters the properties of an entity instance to include only those marked
 * with the @FrontendKey decorator.
 *
 * @template T
 * @param {T} instance - The entity instance to filter.
 * @returns {Partial<T>} A new object containing only the @FrontendKey properties.
 */
export const FilterFrontendKeys = <T extends object>(instance: T): Partial<T> => {
  const proto = Object.getPrototypeOf(instance);
  const keys = frontendKeysByProto.get(proto) ?? new Set<string | symbol>();
  
  return Object.fromEntries(
    Object.entries(instance).filter(([key]) => keys.has(key))
  ) as Partial<T>;
};
