const express = require('express');

const router = express.Router();
const { getAllDeviceTypeController } = require('../controllers');

router.get('/device_type/get', getAllDeviceTypeController);

module.exports = router;
