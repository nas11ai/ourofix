const DataTypes = require('sequelize');

module.exports = {
  up: async ({ context: queryInterface }) => {
    await queryInterface.addColumn('orders', 'status', {
      type: DataTypes.ENUM('Sedang dalam antrian', 'Sedang diperbaiki', 'Selesai'),
      allowNull: false,
      defaultValue: 'Sedang dalam antrian',
    });
  },
  down: async ({ context: queryInterface }) => {
    await queryInterface.removeColumn('orders', 'status');
  },
};
