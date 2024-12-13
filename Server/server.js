const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const uploadService = require('./Services/ImageServices'); 
dotenv.config();
const cors = require('cors');
const app = express();
const port = process.env.PORT;

// Middleware
app.use(express.json());
app.use(cors());
uploadService.setupUpload(app);

// Database Connection
const connectToDatabase = require('./Configs/db');
connectToDatabase();

app.use(cors({
  origin: ['http://127.0.0.1:5500'],
  methods: 'GET, POST, PUT, DELETE',
  credentials: true
}));

// Routes
app.use('/api', require('./Routes/DietRoutes'));
app.use('/api', require('./Routes/UserRoutes'));
app.use('/api', require('./Routes/LoginRoutes'));

// Start server
app.listen(port, () => {
  console.log(`Server is running at http://192.168.1.7:${port}`);
});

app.get('/' , (req, res) => {
  res.send('Hello World!')
});

// Close connection on server close
process.on('SIGINT', async () => {
  await mongoose.connection.close();
  console.log("MongoDB connection closed");
  process.exit(0);
});