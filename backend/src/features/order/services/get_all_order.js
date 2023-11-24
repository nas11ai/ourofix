const { Order, DeviceType } = require('../models');

const getAllOrder = async (req) => Order.findAll({
  attributes: ['id', 'status', 'response_midtrans', 'status_transaksi'],
  where: { user_uid: req.uid },
  order: [['status', 'DESC']],
  include: [
    {
      model: DeviceType,
      as: 'device_type',
      attributes: ['id', 'name'],
    },
  ],
});

module.exports = getAllOrder;
