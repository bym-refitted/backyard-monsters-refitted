export const SESSION_CONFIG = {
  key: "bym-refitted-session", // A unique identifier for your session cookie
  maxAge: 86400000, // Session duration (milliseconds), here set to 24 hours
  overwrite: true, // Allow overwriting the session on each request
  httpOnly: true, // Prevent client-side JavaScript from accessing the session cookie
  signed: true, // Sign the session cookie to prevent tampering
  rolling: false, // Renew the session cookie on each request to extend the session
  renew: false, // Renew the session if the session data has changed (use with rolling)
  secure: false, // Ensure the session cookie is only sent over HTTPS
};
