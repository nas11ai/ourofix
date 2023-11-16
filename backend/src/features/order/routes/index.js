const express = require('express');

const router = express.Router();
const { getAllDeviceTypeController, createNewOrderController } = require('../controllers');
const generateMulter = require('../../../utilities/generate_multer');

const upload = generateMulter('order');

router.get('/device_type/get', getAllDeviceTypeController);

router.post('/create', upload.array('images'), createNewOrderController);

module.exports = router;
