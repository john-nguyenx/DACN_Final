const jwt = require('jsonwebtoken');
const User = require('../Models/User');

const ROLES = {
  USER: 'user',
  ADMIN: 'admin',
};

const authorize = (roles = []) => {
  return async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(403).json({ message: 'Thiếu tiêu đề ủy quyền!' });
    }

    const token = authHeader.split(' ')[1];
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await User.findById(decoded.id);
      
      if (!user ) {
        return res.status(401).json({ message: 'Không được phép! ', data: user });
      }

      if (roles.length && !roles.includes(user.role)) {
        return res.status(403).json({ message: 'Quyền truy cập bị từ chối: không đủ quyền.' });
      }
      console.log(user.role);
      req.user = user; // Attach user to request object
      next();
    } catch (error) {
      console.error('Lỗi ủy quyền:', error); // Log error for debugging
      return res.status(401).json({ message: 'Không được phép: mã thông báo không hợp lệ hoặc đã hết hạn.' });
    }
  };
};

module.exports = { authorize, ROLES };
