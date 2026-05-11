const Food = require('../models/Food');

// GET /api/foods?category=<id>
const getFoods = async (req, res) => {
  try {
    const filter = { isAvailable: true };
    if (req.query.category) {
      filter.category = req.query.category;
    }

    const foods = await Food.find(filter).populate('category', 'name').sort({ name: 1 });
    res.json({ foods });
  } catch (error) {
    res.status(500).json({ message: 'Không thể tải danh sách món ăn' });
  }
};

// GET /api/foods/:id
const getFoodById = async (req, res) => {
  try {
    const food = await Food.findById(req.params.id).populate('category', 'name');
    if (!food) {
      return res.status(404).json({ message: 'Không tìm thấy món ăn' });
    }
    res.json({ food });
  } catch (error) {
    res.status(500).json({ message: 'Không thể tải thông tin món ăn' });
  }
};

module.exports = { getFoods, getFoodById };
