const express = require('express');
const router = express.Router();
const { getCart, addToCart, updateCartItem, removeFromCart, clearCart } = require('../controllers/cart.controller');
const { authenticate } = require('../middleware/auth.middleware');

router.use(authenticate);

router.get('/', getCart);
router.post('/', addToCart);
router.put('/:foodId', updateCartItem);
router.delete('/clear', clearCart);
router.delete('/:foodId', removeFromCart);

module.exports = router;
