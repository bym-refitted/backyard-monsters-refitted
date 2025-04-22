import fs, { FileHandle } from "fs/promises";
import { randomBytes } from "crypto";
import { logging, errorLog } from "./logger";

/**
 * Check if `.env` file exists, if not, copy `env.example` contents
 * to `.env` and auto-generate random secret key
 *
 * @async
 * @returns {Promise<void>} A promise that resolves when the operation is complete.
 * @throws Will log an error if there is an unexpected error during the file operations.
 */
export const firstRunEnv = async () => {
  try {
    const fh: FileHandle = await fs.open(".env", "wx");
    const exampleEnv = await fs.readFile("example.env", "utf8");
    const secretKey = randomBytes(32).toString("hex");
    const populatedSecretKey = exampleEnv.replace(
      "SECRET_KEY=",
      `SECRET_KEY=${secretKey}`
    );

    await Promise.all([
      fh.write(populatedSecretKey, 0, "utf8"),
      !process.env.SECRET_KEY && (process.env.SECRET_KEY = secretKey),
      fh.close(),
    ]);
  } catch (err) {
    if (err.code === "EEXIST") logging(".env file already exists.");
    else errorLog(`Unexpected env copying error, reason: ${err}`);
  }
};
