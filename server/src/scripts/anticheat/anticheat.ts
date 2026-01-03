import { Save } from '../../models/save.model';
import { User } from '../../models/user.model';

let antiCheatModule: { validateSave: (user: User, save: Save) => Promise<void> } | null = null;

async function loadAntiCheatModule() {
  if (antiCheatModule) return antiCheatModule;

  try {
    // @ts-ignore: private module may not exist in development builds
    antiCheatModule = await import('./anticheat.private.js');
    console.log("loading private anticheat");
  } catch {
    antiCheatModule = await import('./anticheat.stub.js');
    console.warn('Anti-cheat stub loaded (development mode)');
  }

  return antiCheatModule;
}

export const validateSave = async (user: User, save: Save) => {
  const module = await loadAntiCheatModule();
  return module.validateSave(user, save);
};
