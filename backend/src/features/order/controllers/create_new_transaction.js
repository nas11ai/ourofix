const { SuccessResponse, DataDetails } = require('../../../utilities/response_model');
const { createNewTransaction } = require('../services');

const createNewTransactionController = async (req, res, next) => {
  try {
    await createNewTransaction(req);

    const response = new SuccessResponse(201, 'CREATED', new DataDetails('transactions', null));

    res.status(response.code).json(response);
  } catch (error) {
    next(error);
  }
};

module.exports = createNewTransactionController;
