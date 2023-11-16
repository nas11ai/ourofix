const { DeviceType } = require('../models');

const getAllDeviceType = async () => DeviceType.findAll({ attributes: ['id', 'name'] });

module.exports = getAllDeviceType;
