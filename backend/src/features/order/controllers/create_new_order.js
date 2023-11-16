const { SuccessResponse, DataDetails } = require('../../../utilities/response_model');
const { createNewOrder } = require('../services');

const createNewOrderController = async (req, res, next) => {
  try {
    await createNewOrder(req);

    const response = new SuccessResponse(201, 'CREATED', new DataDetails('orders', null));

    res.status(response.code).json(response);
  } catch (error) {
    next(error);
  }
};

module.exports = createNewOrderController;
