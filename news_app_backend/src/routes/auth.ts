import { Router } from 'express';
import bcrypt from 'bcrypt';
import pool from '../db.js';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';



const router = Router();
dotenv.config();



router.post('/login', async (req, res) => {

    const { userName, password } = req.body;
    console.log('hitted /login username: ' + userName + ' password: ' + password);
    if (!userName || !password) {

        res.status(400).json({ message: 'Username and password are required' });
    }
    try {
        const result = await pool.query('select * from users where user_name=$1', [userName]);

        if (result.rows.length === 0) {
            res.status(401).json({ message: 'user name' });
        }
        const user = result.rows[0];
        const match = await bcrypt.compare(password, user.password);
        if (!match) {
            res.status(401).json({ message: 'Invalid credentials' });
        }
        const token = "bearer " + await jwt.sign({ userId: user.user_name }, process.env.JWT_SECRET!);

        res.json({ token });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }



})


router.post('/register', async (req, res) => {
    const { userName, password } = req.body;
    console.log('hitted /register username: ' + userName + ' password: ' + password);
    if (!userName || !password) {
        res.end("username and password required");
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const result = await pool.query(
            'insert into users (user_name,password) values($1,$2)', [userName, hashedPassword]
        );
        res.status(201).json({ user: result.rows[0] });
    }
    catch (err: any) {
        if (err.code === '23505') {
            // Unique violation
            res.status(409).json({ message: 'Username already exists' });
        } else {
            console.error(err);
            res.status(500).json({ message: 'Server error' });
        }
    }

})



export default router;