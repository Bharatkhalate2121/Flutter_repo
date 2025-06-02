import jwt from 'jsonwebtoken'
import { Request, Response, NextFunction } from 'express'
import dotenv from 'dotenv'

dotenv.config();

interface AuthRequest extends Request {
    user?: any
}

export function authenticateToken(req: AuthRequest, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];
    const token = authHeader?.split(' ')[1];
    if (!token) {
        return res.status(404).json({ 'message': 'invalid request please login with proper credentials' });
    }
    jwt.verify(token, process.env.JWT_SECRET!, (err, user) => {
        if (err) {
            return res.status(403).json({ 'message': 'invalid request please login with proper credentials' });
        }
        req.user = user;
        next();
    })
}