/* eslint-disable camelcase */
const fs = require('fs');
const { sequelize } = require('../../../configs/db');
const { Order, OrderPhoto, DeviceType } = require('../models');

const generateErrorResponse = require('../../../utilities/generate_error_response');
const HttpStatus = require('../../../utilities/http_status');

const createNewOrder = async (req) => {
  try {
    const { device_type_id, complains } = req.body;

    const user_uid = req.uid;

    if (!user_uid) {
      generateErrorResponse({
        name: 'OrderError',
        attribute: 'user_uid',
        message: 'Kredensial tidak ditemukan!',
        httpStatus: HttpStatus.FORBIDDEN,
      });
    }

    if (typeof device_type_id !== 'string') {
      generateErrorResponse({
        name: 'OrderError',
        attribute: 'device_type_id',
        message: 'Invalid device_type_id',
        httpStatus: HttpStatus.BAD_REQUEST,
      });
    }

    if (typeof complains !== 'string') {
      generateErrorResponse({
        name: 'OrderError',
        attribute: 'complains',
        message: 'Invalid description',
        httpStatus: HttpStatus.BAD_REQUEST,
      });
    }

    const deviceType = DeviceType.findByPk(device_type_id);

    if (!deviceType) {
      generateErrorResponse({
        name: 'OrderError',
        attribute: 'device_type_id',
        message: 'Tipe device tidak ditemukan',
        httpStatus: HttpStatus.NOT_FOUND,
      });
    }
    await sequelize.transaction(async (t) => {
      const order = await Order.create({ user_uid, device_type_id, complains }, {
        transaction: t,
      });

      if (req.files) {
        const photos = req.files.map((photo) => ({
          order_id: order.id,
          photo_path: photo.path,
          photo_url: `/static/order/${order.id}/${photo.filename}`,
        }));

        await OrderPhoto.bulkCreate(photos, { transaction: t });
      }
    });
  } catch (error) {
    if (req.files.length > 0) {
      req.files.forEach((image) => {
        fs.unlink(image.path, (err) => {
          if (err) throw err;
        });
      });
    }

    throw error;
  }
};

module.exports = createNewOrder;
