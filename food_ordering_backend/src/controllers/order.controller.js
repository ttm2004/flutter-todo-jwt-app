const Order = require('../models/Order');
const Cart = require('../models/Cart');
const Food = require('../models/Food');

// POST /api/orders
const createOrder = async (req, res) => {
  try {
    const cart = await Cart.findOne({ user: req.user._id }).populate('items.food');

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ message: 'Giỏ hàng trống' });
    }

    const orderItems = cart.items.map((item) => ({
      food: item.food._id,
      name: item.food.name,
      price: item.food.price,
      quantity: item.quantity
    }));

    const totalAmount = orderItems.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0
    );

    const order = await Order.create({
      user: req.user._id,
      items: orderItems,
      totalAmount
    });

    // Clear cart after order
    cart.items = [];
    await cart.save();

    res.status(201).json({
      message: 'Đặt hàng thành công',
      order: {
        _id: order._id,
        orderCode: order.orderCode,
        items: order.items,
        totalAmount: order.totalAmount,
        status: order.status,
        createdAt: order.createdAt
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Không thể tạo đơn hàng' });
  }
};

// GET /api/orders
const getOrders = async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user._id }).sort({ createdAt: -1 });
    res.json({ orders });
  } catch (error) {
    res.status(500).json({ message: 'Không thể tải đơn hàng' });
  }
};

module.exports = { createOrder, getOrders };
