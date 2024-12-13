const mongoose = require('mongoose');

const connectToDatabase = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("Đã kết nối với mongodb...");
  } catch (error) {
    console.error("Lỗi kết nối với mongodb: ", error);
  }
};

module.exports = connectToDatabase;
