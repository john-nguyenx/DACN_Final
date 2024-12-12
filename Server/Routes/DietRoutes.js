const express = require('express');
const router = express.Router();
const dietController = require('../Controllers/DietController');

router.post('/post_diet', dietController.postDiet);
router.get('/get_diet', dietController.getDiet);

module.exports = router;
