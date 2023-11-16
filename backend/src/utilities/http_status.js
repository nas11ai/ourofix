class HttpStatus {
  static BAD_REQUEST = {
    code: 400,
    status: 'BAD_REQUEST',
  };

  static UNAUTHORIZED = {
    code: 401,
    status: 'UNAUTHORIZED',
  };

  static FORBIDDEN = {
    code: 403,
    status: 'FORBIDDEN',
  };

  static NOT_FOUND = {
    code: 404,
    status: 'NOT_FOUND',
  };
}

module.exports = HttpStatus;
