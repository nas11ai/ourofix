const path = require('path');
const fs = require('fs');
const multer = require('multer');

const HttpStatus = require('./http_status');
const { ErrorDetails, ErrorResponse } = require('./response_model');
const generateErrorResponse = require('./generate_error_response');

const generateMulter = (assetType) => {
  if (typeof assetType !== 'string') {
    generateErrorResponse({
      name: 'MulterError',
      attribute: 'asset_type',
      message: 'asset_type must be string',
      httpStatus: HttpStatus.BAD_REQUEST,
    });
  }

  return multer({
    storage: multer.diskStorage({
      destination(req, file, cb) {
        const imagePath = path.join(path.resolve(''), 'assets', `${assetType}`, req.body.username || req.params.username || req.params.category_name || req.body.name || req.uid);

        if (!fs.existsSync(imagePath)) {
          fs.mkdirSync(imagePath, { recursive: true });
        }

        cb(null, imagePath);
      },
      filename(req, file, cb) {
        const date = new Date();
        const year = date.getFullYear();
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        const day = date.getDate().toString().padStart(2, '0');
        const hours = date.getHours().toString().padStart(2, '0');
        const minutes = date.getMinutes().toString().padStart(2, '0');
        const seconds = date.getSeconds().toString().padStart(2, '0');
        const formattedDate = `${year}-${month}-${day}-${hours}-${minutes}-${seconds}`;

        cb(null, `${req.body.username || req.params.username || req.params.category_name || req.body.name}_${formattedDate}_${file.originalname}`);
      },
    }),
    fileFilter(req, file, cb) {
      // allow only .jpg and .png files
      const filetypes = /jpeg|jpg|png/;
      const mimetype = filetypes.test(file.mimetype);
      const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

      if (mimetype && extname) {
        cb(null, true); // Success, return null for the error and true for allowing the file
      } else {
        const err = new ErrorDetails('MulterError', 'file_type', 'Only .jpg and .png files are allowed');
        // TODO: ganti console ke log kalau sudah mau production
        // eslint-disable-next-line no-console
        console.error(err);
        cb(new ErrorResponse(400, 'BAD_REQUEST', { [err.attribute]: err.message })); // Error, return the error object
      }
    },
    limits: {
      fileSize: 10 * 1024 * 1024, // set max file size to 10MB
    },
  });
};

module.exports = generateMulter;
