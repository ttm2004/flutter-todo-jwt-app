const express = require('express');
const router = express.Router();
const { getFoods, getFoodById } = require('../controllers/food.controller');
const { authenticate } = require('../middleware/auth.middleware');

router.get('/', authenticate, getFoods);
router.get('/:id', authenticate, getFoodById);

module.exports = router;
