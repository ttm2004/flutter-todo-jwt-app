const Cart = require('../models/Cart');
const Food = require('../models/Food');

const populateCart = (cart) => cart.populate({ path: 'items.food', select: 'name price image description' });

// GET /api/cart
const getCart = async (req, res) => {
  try {
    let cart = await Cart.findOne({ user: req.user._id });
    if (!cart) {
      cart = await Cart.create({ user: req.user._id, items: [] });
    }
    await populateCart(cart);
    res.json({ cart: formatCart(cart) });
  } catch (error) {
    res.status(500).json({ message: 'Không thể tải giỏ hàng' });
  }
};

// POST /api/cart  { foodId, quantity }
const addToCart = async (req, res) => {
  try {
    const { foodId, quantity = 1 } = req.body;

    if (!foodId) {
      return res.status(400).json({ message: 'foodId là bắt buộc' });
    }

    const food = await Food.findById(foodId);
    if (!food) {
      return res.status(404).json({ message: 'Không tìm thấy món ăn' });
    }

    let cart = await Cart.findOne({ user: req.user._id });
    if (!cart) {
      cart = new Cart({ user: req.user._id, items: [] });
    }

    const existingIndex = cart.items.findIndex(
      (item) => item.food.toString() === foodId
    );

    if (existingIndex >= 0) {
      cart.items[existingIndex].quantity += quantity;
    } else {
      cart.items.push({ food: foodId, quantity });
    }

    await cart.save();
    await populateCart(cart);

    res.json({ message: 'Đã thêm vào giỏ hàng', cart: formatCart(cart) });
  } catch (error) {
    res.status(500).json({ message: 'Không thể thêm vào giỏ hàng' });
  }
};

// PUT /api/cart/:foodId  { quantity }
const updateCartItem = async (req, res) => {
  try {
    const { quantity } = req.body;
    const { foodId } = req.params;

    if (quantity === undefined || quantity < 0) {
      return res.status(400).json({ message: 'Số lượng không hợp lệ' });
    }

    let cart = await Cart.findOne({ user: req.user._id });
    if (!cart) {
      return res.status(404).json({ message: 'Giỏ hàng không tồn tại' });
    }

    if (quantity === 0) {
      cart.items = cart.items.filter((item) => item.food.toString() !== foodId);
    } else {
      const index = cart.items.findIndex((item) => item.food.toString() === foodId);
      if (index === -1) {
        return res.status(404).json({ message: 'Món ăn không có trong giỏ hàng' });
      }
      cart.items[index].quantity = quantity;
    }

    await cart.save();
    await populateCart(cart);

    res.json({ message: 'Đã cập nhật giỏ hàng', cart: formatCart(cart) });
  } catch (error) {
    res.status(500).json({ message: 'Không thể cập nhật giỏ hàng' });
  }
};

// DELETE /api/cart/:foodId
const removeFromCart = async (req, res) => {
  try {
    const { foodId } = req.params;

    const cart = await Cart.findOne({ user: req.user._id });
    if (!cart) {
      return res.status(404).json({ message: 'Giỏ hàng không tồn tại' });
    }

    cart.items = cart.items.filter((item) => item.food.toString() !== foodId);
    await cart.save();
    await populateCart(cart);

    res.json({ message: 'Đã xóa khỏi giỏ hàng', cart: formatCart(cart) });
  } catch (error) {
    res.status(500).json({ message: 'Không thể xóa khỏi giỏ hàng' });
  }
};

// DELETE /api/cart
const clearCart = async (req, res) => {
  try {
    await Cart.findOneAndUpdate(
      { user: req.user._id },
      { items: [] },
      { upsert: true }
    );
    res.json({ message: 'Đã xóa toàn bộ giỏ hàng' });
  } catch (error) {
    res.status(500).json({ message: 'Không thể xóa giỏ hàng' });
  }
};

const formatCart = (cart) => {
  const items = cart.items.map((item) => ({
    food: item.food,
    quantity: item.quantity,
    subtotal: item.food.price * item.quantity
  }));
  const totalAmount = items.reduce((sum, item) => sum + item.subtotal, 0);
  return { _id: cart._id, items, totalAmount };
};

module.exports = { getCart, addToCart, updateCartItem, removeFromCart, clearCart };
