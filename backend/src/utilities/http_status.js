// httpStatus.js

class HttpStatus {
  static BAD_REQUEST = {
    code: 400,
    status: 'BAD_REQUEST',
  };

  static UNAUTHORIZED = {
    code: 401,
    status: 'UNAUTHORIZED',
  };

  static NOT_FOUND = {
    code: 404,
    status: 'NOT_FOUND',
  };
}

module.exports = HttpStatus;
