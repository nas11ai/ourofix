const { ErrorResponse, ErrorDetails } = require('./response_model');
const HttpStatus = require('./http_status');
const ValidationError = require('./validation_error');

const generateErrorResponse = (name, attribute, message, httpStatus = HttpStatus.BAD_REQUEST) => {
  if (
    typeof name !== 'string'
    || typeof attribute !== 'string'
    || typeof message !== 'string'
    || !(httpStatus instanceof HttpStatus)
  ) {
    throw new ValidationError('Invalid parameter types for generateErrorResponse');
  }

  const err = new ErrorDetails({ name, attribute, message });

  // eslint-disable-next-line no-console
  console.error(err);
  throw new ErrorResponse(httpStatus.code, httpStatus.status, { message: err.message });
};

module.exports = generateErrorResponse;
