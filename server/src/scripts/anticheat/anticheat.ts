import { Save } from '../../models/save.model.js';
import { User } from '../../models/user.model.js';
import { Env } from '../../enums/Env.js';

interface AntiCheatModule {
  initialize: () => Promise<void>;
  validateSave: (user: User, save: Save, rawBody: unknown) => Promise<void>;
}

let antiCheatModule: AntiCheatModule | null = null;

async function loadAntiCheatModule() {
  if (antiCheatModule) return antiCheatModule;

  if (process.env.ENV !== Env.PROD)
    return antiCheatModule = await import('./pub/anticheat.stub.js');

  try {
    // @ts-ignore: private module may not exist in development builds
    antiCheatModule = await import('./priv/anticheat.private.js');
  } catch {
    antiCheatModule = await import('./pub/anticheat.stub.js');
  }

  return antiCheatModule;
}

export const initAnticheat = async () => {
  const module = await loadAntiCheatModule();
  await module.initialize();
};

export const validateSave = async (user: User, save: Save, rawBody: unknown) => {
  const module = await loadAntiCheatModule();
  return module.validateSave(user, save, rawBody);
};
