const express = require('express');
const router = express.Router();
const { createOrder, getOrders } = require('../controllers/order.controller');
const { authenticate } = require('../middleware/auth.middleware');

router.use(authenticate);

router.post('/', createOrder);
router.get('/', getOrders);

module.exports = router;
