const { ErrorResponse } = require('../utilities/response_model');

const errorHandler = (err, req, res) => {
  if (err instanceof ErrorResponse) {
    res.status(err.code).json(err);
    return;
  }
  // TODO: ganti console ke log kalau sudah mau production
  // eslint-disable-next-line no-console
  console.error(err);

  const unknownErr = new ErrorResponse(500, 'INTERNAL_SERVER_ERROR', { message: err.message });
  res.status(unknownErr.code).json(unknownErr);
};

module.exports = errorHandler;
