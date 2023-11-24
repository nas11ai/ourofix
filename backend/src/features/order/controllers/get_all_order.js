// const { SuccessResponse, DataDetails } = require('../../../utilities/response_model');
const { getAllOrder } = require('../services');

const getAllOrderController = async (req, res, next) => {
  try {
    const orders = await getAllOrder(req);

    // const response = new SuccessResponse(200, 'OK', new DataDetails('orders', orders));

    res.status(201).json({ orders });
  } catch (error) {
    next(error);
  }
};

module.exports = getAllOrderController;
