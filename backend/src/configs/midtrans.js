/* eslint-disable import/no-extraneous-dependencies */
const midtransClient = require('midtrans-client');
const { MIDTRANS_SERVER_KEY, MIDTRANS_CLIENT_KEY } = require('./config');

const coreApi = new midtransClient.CoreApi({
  isProduction: false,
  serverKey: MIDTRANS_SERVER_KEY, // // sesuaikan dengan akun midtrans anda
  clientKey: MIDTRANS_CLIENT_KEY, // sesuaikan dengan akun midtrans anda
});

module.exports = coreApi;
