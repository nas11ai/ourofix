const { SuccessResponse, DataDetails } = require('../../../utilities/response_model');
const { getAllDeviceType } = require('../services');

const getAllDeviceTypeController = async (req, res, next) => {
  try {
    const deviceTypes = await getAllDeviceType();

    const response = new SuccessResponse(200, 'OK', new DataDetails('device_type', deviceTypes));

    res.status(response.code).json(response);
  } catch (error) {
    next(error);
  }
};

module.exports = getAllDeviceTypeController;
