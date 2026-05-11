const express = require('express');
const router = express.Router();
const { getCategories } = require('../controllers/category.controller');
const { authenticate } = require('../middleware/auth.middleware');

router.get('/', authenticate, getCategories);

module.exports = router;
