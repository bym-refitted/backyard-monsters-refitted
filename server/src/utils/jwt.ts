import * as jwt from 'jsonwebtoken'

declare module 'jsonwebtoken' {
    export interface UserIDJwtPayload extends jwt.JwtPayload {
        userId: number
    }
}
