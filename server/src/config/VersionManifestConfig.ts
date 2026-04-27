interface VersionManifest {
  currentGameVersion: string;
  currentLauncherVersion: string;
  httpsWorked: boolean;
}

let manifest: VersionManifest | null = null;

/**
 * Fetches and caches the version manifest from the CDN.
 * This should be called once during server startup to initialize the manifest data.
 *
 * @returns {Promise<void>}
 * @throws {Error} If the CDN request fails
 */
export const initialize = async (): Promise<void> => {
  const manifestUrl = process.env.CDN_URL + "/versionManifest.json";
  const response = await fetch(manifestUrl);

  if (!response.ok) throw new Error(`HTTP ${response.status} fetching version manifest`);

  manifest = await response.json();
};

/**
 * Returns the current game version string formatted for API versioning and SWF filenames.
 * e.g. "v1.6.1-beta"
 *
 * @returns {string}
 */
export const getGameVersion = (): string => {
  if (!manifest) throw new Error("Version manifest not initialized");

  return `v${manifest.currentGameVersion}-beta`;
};
