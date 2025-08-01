import { open, readFile } from 'fs/promises'
import { randomBytes } from 'crypto';

/**
 * Environment file setup utility for build processes
 * 
 * Automatically creates a .env file from example.env template with a randomly 
 * generated SECRET_KEY if .env doesn't already exist. This ensures the 
 * application has the required environment configuration before compilation.
 * 
 * @async
 * @function
 * @returns {Promise<void>} A promise that resolves when the operation is complete
 * @throws {Error} Will exit process if there's an unexpected error during file operations
 */
(async () => {
  try {
    const fh = await open(".env", "wx");
    const exampleEnv = await readFile("example.env", "utf8");
    const secretKey = randomBytes(32).toString("hex");
    const populatedSecretKey = exampleEnv.replace(
      "SECRET_KEY=",
      `SECRET_KEY=${secretKey}`
    );

    await fh.write(populatedSecretKey, 0, "utf8");
    await fh.close();
    
    console.log("✅ Created .env file with generated SECRET_KEY");
  } catch (err) {
    if (err.code === "EEXIST") {
      console.log(".env file already exists.");
    } else {
      console.error(`❌ Unexpected env copying error: ${err.message}`);
      process.exit(1);
    }
  }
})();
