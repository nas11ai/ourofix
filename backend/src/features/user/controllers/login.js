const { SuccessResponse, DataDetails } = require('../../../../utilities/response_model');
const { loginService } = require('../services');

const loginController = async (req, res, next) => {
  try {
    const { newAccessToken, newRefreshToken, userRole } = await loginService(req);

    // res.cookie('jwt', newRefreshToken, {
    //   httpOnly: true,
    //   sameSite: 'None',
    //   // sameSite: 'strict',
    //   secure: true,
    //   // secure: false,
    //   //TODO: Ganti ke 1 hari kalau deployment
    //   maxAge: 24 * 60 * 60 * 1000,
    //   // maxAge: 15 * 60 * 1000,
    // });

    const response = new SuccessResponse({
      code: 200,
      status: 'OK',
      data: new DataDetails({
        type: 'login',
        attributes: {
          user_role: userRole,
          access_token: newAccessToken,
          refresh_token: newRefreshToken,
        },
      }),
    });

    res.status(response.code).json(response);
  } catch (error) {
    next(error);
  }
};

module.exports = loginController;
