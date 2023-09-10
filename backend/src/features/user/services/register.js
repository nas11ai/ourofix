const bcrypt = require('bcrypt');

const { User } = require('../models');

const generateErrorResponse = require('../../../utilities/generate_error_response');
const HttpStatus = require('../../../utilities/http_status');

const registerService = async (req) => {
  const {
    username,
    role,
    password,
    email,
  } = req.body;

  if (typeof username !== 'string') {
    generateErrorResponse({
      name: 'RegisterError',
      attribute: 'username',
      message: 'username harus berupa string dan tidak boleh kosong!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  const user = await User.findOne({ where: { username } });

  if (user) {
    generateErrorResponse({
      name: 'RegisterError',
      attribute: 'username',
      message: 'username telah digunakan!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  if (typeof role !== 'string') {
    generateErrorResponse({
      name: 'RegisterError',
      attribute: 'role',
      message: 'role harus berupa string dan tidak boleh kosong!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  if (typeof password !== 'string') {
    generateErrorResponse({
      name: 'RegisterError',
      attribute: 'password',
      message: 'password harus berupa string dan tidak boleh kosong!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  if (typeof email !== 'string') {
    generateErrorResponse({
      name: 'RegisterError',
      attribute: 'email',
      message: 'email harus berupa string dan tidak boleh kosong!',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  const saltRounds = 10;
  // eslint-disable-next-line camelcase
  const password_hash = await bcrypt.hash(password, saltRounds);

  try {
    await User.create({
      // eslint-disable-next-line camelcase
      username, role, email, password_hash,
    });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      generateErrorResponse({
        name: error.name,
        attribute: 'username',
        message: 'username telah digunakan!',
        httpStatus: HttpStatus.BAD_REQUEST,
      });
    }

    if (error.name === 'SequelizeDatabaseError') {
      generateErrorResponse({
        name: error.name,
        attribute: 'role',
        message: 'role hanya menerima value (superadmin)/(admin)/(user)!',
        httpStatus: HttpStatus.BAD_REQUEST,
      });
    }
  }
};

module.exports = registerService;
