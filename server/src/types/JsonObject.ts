/**
 * An arbitrary JSON object received from or sent to the Flash client.
 * Used for opaque blob columns where the server stores and forwards
 * data without inspecting its internal structure.
 * 
 * TODO: At some point we should probably define more specific types for the various JSON blobs
 */
export type JsonObject = Record<string, any>;
