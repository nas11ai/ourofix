const express = require('express');

const router = express.Router();
const {
  getAllDeviceTypeController,
  createNewOrderController,
  getAllOrderController,
  createNewTransactionController,
} = require('../controllers');
const generateMulter = require('../../../utilities/generate_multer');

const upload = generateMulter('order');

router.get('/device_type/get', getAllDeviceTypeController);

router.post('/create', upload.array('images'), createNewOrderController);
router.get('/get', getAllOrderController);

router.post('/transaction/create', createNewTransactionController);

module.exports = router;
