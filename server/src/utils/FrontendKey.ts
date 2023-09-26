import 'reflect-metadata';

const FrontendKeyMetadataKey = Symbol('FrontendKey');

export function FrontendKey(target: any, propertyKey: string) {
    Reflect.defineMetadata(FrontendKeyMetadataKey, true, target, propertyKey);
}
  
export function FilterFrontendKeys<T>(instance: T): Partial<T> {
    const filteredObject: Partial<T> = {};
    
    for (const key in instance) {
      if (instance.hasOwnProperty(key) && Reflect.getMetadata(FrontendKeyMetadataKey, instance, key)) {
        filteredObject[key] = instance[key];
      }
    }
    
    return filteredObject;
  }