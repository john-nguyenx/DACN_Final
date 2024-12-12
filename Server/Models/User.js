const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  
  name: {
    type: String,
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  gender: {
    type: String,
    enum: ['Nam', 'Nữ', 'Khác'],
  },
  address: {
    type: String,
  },
  phone: {
    type: String,
  },
  image: {
    type: String,
  },
  role: {
    type: String,
    enum: ['user', 'admin'], // Define possible roles
    default: 'user' // Default role
  },
  isVerified: {
    type: Boolean,
    default: false,
  }, toKen: {
    type: String,
    require: true
  },
  lastLogin: {
    type: Date,
    default: Date.now,
  },
    
}, { timestamps: true },
{ versionKey: false });
module.exports = mongoose.model('User', userSchema);
