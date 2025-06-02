import express from 'express';
import authRoutes from './routes/auth.js';

const app = express();
const PORT = 3000;

// Middleware to parse JSON
app.use(express.json());
app.use('/', authRoutes);

app.get('/', (req, res) => {
  console.log('/ hitted');
  res.send('API is running...');
});

// Start the server
app.listen(PORT, '192.168.90.210', () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
