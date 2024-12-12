const express = require('express');
const router = express.Router();
const dietController = require('../Controllers/DietController');

//add thực phẩm
router.post('/post_diet', dietController.postDiet);

//lấy thực phẩm
router.get('/get_diet', dietController.getDiet);

module.exports = router;
