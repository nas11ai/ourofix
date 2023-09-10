const { ErrorResponse } = require('../utilities/response_model');

const errorHandler = (err, req, res) => {
  if (err instanceof ErrorResponse) {
    res.status(err.code).json(err);
    return;
  }
  // TODO: ganti console ke log kalau sudah mau production
  // eslint-disable-next-line no-console
  console.error(err);
  res.status(500).json({
    name: err.name,
    message: err.message,
  });
};

module.exports = errorHandler;
