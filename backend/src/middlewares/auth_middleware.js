const firebase = require('../configs/firebase');
const generateErrorResponse = require('../utilities/generate_error_response');
const HttpStatus = require('../utilities/http_status');

const authMiddleware = (request, response, next) => {
  const headerToken = request.headers.authorization;
  if (!headerToken) {
    const errorResponse = generateErrorResponse({
      name: 'JwtError',
      attribute: 'token',
      message: 'token tidak ditemukan!',
      httpStatus: HttpStatus.UNAUTHORIZED,
    });
    return response.status(errorResponse.code).json(errorResponse);
  }

  if (headerToken && headerToken.split(' ')[0] !== 'Bearer') {
    const errorResponse = generateErrorResponse({
      name: 'JwtError',
      attribute: 'token',
      message: 'Invalid token',
      httpStatus: HttpStatus.UNAUTHORIZED,
    });
    return response.status(errorResponse.code).json(errorResponse);
  }

  const token = headerToken.split(' ')[1];

  return firebase
    .auth()
    .verifyIdToken(token)
    .then(() => next())
    .catch((error) => {
      const errorResponse = generateErrorResponse({
        name: 'JwtError',
        attribute: 'token',
        message: error.message,
        httpStatus: HttpStatus.FORBIDDEN,
      });
      return response.status(errorResponse.code).json(errorResponse);
    });
};

module.exports = authMiddleware;
