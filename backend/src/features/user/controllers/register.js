const { SuccessResponse, DataDetails } = require('../../../../utilities/response_model');
const { registerService } = require('../services');

const registerController = async (req, res, next) => {
  try {
    await registerService(req);

    const response = new SuccessResponse(201, 'CREATED', new DataDetails('users', null));

    res.status(response.code).json(response);
  } catch (error) {
    next(error);
  }
};

module.exports = registerController;
