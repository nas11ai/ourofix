const getAllDeviceType = require('./get_all_device_type');
const createNewOrder = require('./create_new_order');
const getAllOrder = require('./get_all_order');
const createNewTransaction = require('./create_new_transaction');

module.exports = {
  getAllDeviceType,
  createNewOrder,
  createNewTransaction,
  getAllOrder,
};
