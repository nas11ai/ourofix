const DataTypes = require('sequelize');

module.exports = {
  up: async ({ context: queryInterface }) => {
    await queryInterface.addColumn('orders', 'status', {
      type: DataTypes.ENUM('Sedang dalam antrian', 'Sedang diperbaiki', 'Selesai'),
      allowNull: false,
      defaultValue: 'Sedang dalam antrian',
      validate: {
        notNull: {
          msg: 'Status perbaikan tidak boleh kosong!',
        },
        isIn: {
          args: [['Sedang dalam antrian', 'Sedang diperbaiki', 'Selesai']],
          msg: 'Status perbaikan tidak valid!',
        },
      },
    });
    await queryInterface.addColumn('orders', 'response_midtrans', {
      type: DataTypes.TEXT('long'),
      allowNull: true,
    });
    await queryInterface.addColumn('orders', 'status_transaksi', {
      type: DataTypes.STRING,
      allowNull: false,
    });
  },
  down: async ({ context: queryInterface }) => {
    await queryInterface.removeColumn('orders', 'status');
    await queryInterface.removeColumn('orders', 'response_midtrans');
    await queryInterface.removeColumn('orders', 'status_transaksi');
  },
};
