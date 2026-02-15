import { Save } from '../../models/save.model.js';
import { User } from '../../models/user.model.js';
import { Env } from '../../enums/Env.js';

let antiCheatModule: { validateSave: (user: User, save: Save) => Promise<void> } | null = null;

async function loadAntiCheatModule() {
  if (antiCheatModule) return antiCheatModule;

  if (process.env.ENV !== Env.PROD) 
    return antiCheatModule = await import('./anticheat.stub.js');

  try {
    // @ts-ignore: private module may not exist in development builds
    antiCheatModule = await import('./anticheat.private.js');
  } catch {
    antiCheatModule = await import('./anticheat.stub.js');
  }

  return antiCheatModule;
}

export const validateSave = async (user: User, save: Save) => {
  const module = await loadAntiCheatModule();
  return module.validateSave(user, save);
};
