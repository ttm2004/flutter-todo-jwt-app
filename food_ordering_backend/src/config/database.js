const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI);
    console.log(`MongoDB connected: ${conn.connection.host}`);
    await seedData();
  } catch (error) {
    console.error('MongoDB connection error:', error.message);
    process.exit(1);
  }
};

// Seed initial categories and foods if empty
const seedData = async () => {
  const Category = require('../models/Category');
  const Food = require('../models/Food');

  const count = await Category.countDocuments();
  if (count > 0) return;

  console.log('Seeding initial data...');

  const categories = await Category.insertMany([
    { name: 'Món Việt', description: 'Các món ăn truyền thống Việt Nam', image: 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400' },
    { name: 'Món Nhật', description: 'Ẩm thực Nhật Bản', image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400' },
    { name: 'Món Hàn', description: 'Ẩm thực Hàn Quốc', image: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400' },
    { name: 'Đồ Uống', description: 'Nước giải khát và đồ uống', image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400' },
    { name: 'Tráng Miệng', description: 'Bánh và tráng miệng', image: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=400' },
  ]);

  await Food.insertMany([
    // Món Việt
    { category: categories[0]._id, name: 'Phở Bò', description: 'Phở bò truyền thống với nước dùng đậm đà, thịt bò tươi và rau thơm', price: 65000, image: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400' },
    { category: categories[0]._id, name: 'Bún Bò Huế', description: 'Bún bò Huế cay nồng đặc trưng miền Trung', price: 60000, image: 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400' },
    { category: categories[0]._id, name: 'Cơm Tấm Sườn', description: 'Cơm tấm sườn nướng thơm ngon với bì chả', price: 55000, image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400' },
    { category: categories[0]._id, name: 'Bánh Mì Thịt', description: 'Bánh mì giòn với nhân thịt nguội, pate và rau sống', price: 30000, image: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=400' },
    // Món Nhật
    { category: categories[1]._id, name: 'Sushi Cá Hồi', description: 'Sushi cá hồi tươi ngon theo phong cách Nhật Bản', price: 120000, image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400' },
    { category: categories[1]._id, name: 'Ramen Tonkotsu', description: 'Mì ramen với nước dùng xương heo đậm đà', price: 95000, image: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400' },
    { category: categories[1]._id, name: 'Tempura Tôm', description: 'Tôm chiên giòn kiểu Nhật với nước chấm đặc biệt', price: 110000, image: 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400' },
    // Món Hàn
    { category: categories[2]._id, name: 'Bibimbap', description: 'Cơm trộn Hàn Quốc với rau củ và thịt bò', price: 85000, image: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400' },
    { category: categories[2]._id, name: 'Tteokbokki', description: 'Bánh gạo cay Hàn Quốc sốt gochujang', price: 70000, image: 'https://images.unsplash.com/photo-1635363638580-c2809d049eee?w=400' },
    { category: categories[2]._id, name: 'Gà Chiên Hàn', description: 'Gà chiên giòn sốt cay ngọt kiểu Hàn', price: 90000, image: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400' },
    // Đồ Uống
    { category: categories[3]._id, name: 'Trà Sữa Trân Châu', description: 'Trà sữa thơm ngon với trân châu đen', price: 45000, image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400' },
    { category: categories[3]._id, name: 'Cà Phê Sữa Đá', description: 'Cà phê Việt Nam đậm đà với sữa đặc', price: 35000, image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400' },
    { category: categories[3]._id, name: 'Nước Ép Cam', description: 'Nước ép cam tươi nguyên chất', price: 40000, image: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400' },
    // Tráng Miệng
    { category: categories[4]._id, name: 'Chè Ba Màu', description: 'Chè ba màu truyền thống với đậu xanh, đậu đỏ và thạch', price: 30000, image: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=400' },
    { category: categories[4]._id, name: 'Bánh Flan', description: 'Bánh flan mềm mịn với caramel thơm ngon', price: 25000, image: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400' },
  ]);

  console.log('Seed data completed!');
};

module.exports = connectDB;
