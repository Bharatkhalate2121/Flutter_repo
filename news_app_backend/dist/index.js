import express from 'express';
const app = express();
const PORT = 3000;
// Middleware to parse JSON
app.use(express.json());
// A simple route
app.get('/', (req, res) => {
    res.send('Hello, Express + TypeScript!');
});
// Start the server
app.listen(PORT, () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});
