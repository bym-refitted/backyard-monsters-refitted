interface VersionManifest {
  currentGameVersion: string;
  currentLauncherVersion: string;
  httpsWorked: boolean;
}

let manifest: VersionManifest | null = null;

/**
 * Fetches and caches the version manifest from the CDN.
 * No-ops when USE_VERSION_MANAGEMENT is not "enabled".
 * Should be called once during server startup.
 *
 * @returns {Promise<void>}
 * @throws {Error} If the CDN request fails
 */
export const initialize = async (): Promise<void> => {
  if (process.env.USE_VERSION_MANAGEMENT !== "enabled") return;

  const manifestUrl = process.env.CDN_URL + "/versionManifest.json";
  const response = await fetch(manifestUrl);

  if (!response.ok) throw new Error(`HTTP ${response.status} fetching version manifest`);

  manifest = await response.json();
};

/**
 * Returns the current game version string, or null if version management is disabled.
 * e.g. "v1.6.1-beta"
 *
 * @returns {string | null}
 */
export const getGameVersion = (): string | null => {
  if (!manifest) return null;
  return `v${manifest.currentGameVersion}-beta`;
};
