/**
 * Enum representing HTTP status codes.
 * These status codes are used to indicate the result of a HTTP request.
 * 
 * @enum {number}
 */
export enum Status {
  OK = 200,
  CREATED = 201,
  NO_CONTENT = 204,
  BAD_REQUEST = 400,
  UNAUTHORIZED = 401,
  FORBIDDEN = 403,
  NOT_FOUND = 404,
  CONFLICT = 409,
  TOO_MANY_REQUESTS = 429,
  INTERNAL_SERVER_ERROR = 500
}
