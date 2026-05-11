const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const User = require('../models/User');

const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d'
  });
};

// POST /api/auth/register
const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Vui lòng điền đầy đủ thông tin' });
    }

    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(409).json({ message: 'Email này đã được đăng ký' });
    }

    const user = await User.create({ name, email, password });
    const token = generateToken(user._id);

    res.status(201).json({
      message: 'Đăng ký thành công',
      token,
      user: { id: user._id, name: user.name, email: user.email }
    });
  } catch (error) {
    if (error.name === 'ValidationError') {
      const msg = Object.values(error.errors)[0].message;
      return res.status(400).json({ message: msg });
    }
    res.status(500).json({ message: 'Đăng ký thất bại' });
  }
};

// POST /api/auth/login
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Vui lòng nhập email và mật khẩu' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Email hoặc mật khẩu không đúng' });
    }

    const token = generateToken(user._id);

    res.json({
      message: 'Đăng nhập thành công',
      token,
      user: { id: user._id, name: user.name, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ message: 'Đăng nhập thất bại' });
  }
};

// POST /api/auth/forgot-password
const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({ message: 'Vui lòng nhập email' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      // Return success to prevent email enumeration
      return res.json({ message: 'Nếu email tồn tại, chúng tôi đã gửi hướng dẫn khôi phục mật khẩu' });
    }

    const resetToken = crypto.randomBytes(32).toString('hex');
    user.resetPasswordToken = crypto.createHash('sha256').update(resetToken).digest('hex');
    user.resetPasswordExpires = Date.now() + 10 * 60 * 1000; // 10 minutes
    await user.save({ validateBeforeSave: false });

    res.json({ message: 'Nếu email tồn tại, chúng tôi đã gửi hướng dẫn khôi phục mật khẩu' });
  } catch (error) {
    res.status(500).json({ message: 'Không thể xử lý yêu cầu' });
  }
};

// GET /api/auth/me
const getMe = async (req, res) => {
  res.json({
    user: { id: req.user._id, name: req.user.name, email: req.user.email }
  });
};

// PUT /api/auth/profile
const updateProfile = async (req, res) => {
  try {
    const { name, currentPassword, newPassword } = req.body;
    const user = await User.findById(req.user._id);

    if (name && name.trim()) {
      user.name = name.trim();
    }

    if (newPassword) {
      if (!currentPassword) {
        return res.status(400).json({ message: 'Vui lòng nhập mật khẩu hiện tại' });
      }
      const isMatch = await user.comparePassword(currentPassword);
      if (!isMatch) {
        return res.status(400).json({ message: 'Mật khẩu hiện tại không đúng' });
      }
      if (newPassword.length < 6) {
        return res.status(400).json({ message: 'Mật khẩu mới phải có ít nhất 6 ký tự' });
      }
      user.password = newPassword;
    }

    await user.save();

    res.json({
      message: 'Cập nhật thông tin thành công',
      user: { id: user._id, name: user.name, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ message: 'Không thể cập nhật thông tin' });
  }
};

module.exports = { register, login, forgotPassword, getMe, updateProfile };
