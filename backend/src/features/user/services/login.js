const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const crypto = require('crypto');

const { User } = require('../models');
const {
  REFRESH_TOKEN_SECRET,
  ACCESS_TOKEN_SECRET,
  TOKEN_ALGORITHM,
  TOKEN_ISSUER,
  TOKEN_AUDIENCE,
} = require('../../../configs/config');

const generateErrorResponse = require('../../../utilities/generate_error_response');
const HttpStatus = require('../../../utilities/http_status');

const loginService = async (req) => {
  const user = await User.findOne({
    where: {
      username: req.body.username,
    },
  });

  if (!user) {
    generateErrorResponse({
      name: 'LoginFormError',
      attribute: 'username',
      message: 'username salah!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  const passwordExists = user
    ? await bcrypt.compare(req.body.password, user.password_hash)
    : false;

  if (!passwordExists) {
    generateErrorResponse({
      name: 'LoginFormError',
      attribute: 'password',
      message: 'password salah!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  const newAccessToken = jwt.sign({
    userId: user.id,
    userRole: user.role,
    username: user.username,
  }, ACCESS_TOKEN_SECRET, {
    algorithm: TOKEN_ALGORITHM,
    issuer: TOKEN_ISSUER,
    audience: TOKEN_AUDIENCE,
    // TODO: Change to 10 minute when production
    expiresIn: '10m',
    // expiresIn: '1m',
  });

  const newRefreshToken = jwt.sign({
    userId: user.id,
  }, REFRESH_TOKEN_SECRET, {
    jwtid: crypto.randomUUID(),
    algorithm: TOKEN_ALGORITHM,
    issuer: TOKEN_ISSUER,
    audience: TOKEN_AUDIENCE,
    // TODO: Change to 1 day when production
    expiresIn: '1d',
    // expiresIn: '15m',
  });

  return {
    newAccessToken,
    newRefreshToken,
    userRole: user.role,
  };
};

module.exports = loginService;
