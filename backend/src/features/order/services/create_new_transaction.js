const { Order } = require('../models');

const generateErrorResponse = require('../../../utilities/generate_error_response');
const HttpStatus = require('../../../utilities/http_status');
const coreApi = require('../../../configs/midtrans');

const createNewTransaction = async (req) => {
  if (Object.keys(req.body).length === 0) {
    generateErrorResponse({
      name: 'TransactionError',
      attribute: 'body',
      message: 'Konten tidak boleh kosong!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  const chargeResponse = await coreApi.charge(req.body);

  const order = await Order.findByPk(chargeResponse.order_id);

  if (!order) {
    generateErrorResponse({
      name: 'TransactionError',
      attribute: 'order',
      message: 'Pesanan tidak ditemukan!',
      httpStatus: HttpStatus.NOT_FOUND,
    });
  }

  order.status_transaksi = 'success';
  order.response_midtrans = JSON.stringify(chargeResponse);

  order.save();
};

module.exports = createNewTransaction;
