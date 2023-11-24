const DataTypes = require('sequelize');

module.exports = {
  up: async ({ context: queryInterface }) => {
    await queryInterface.changeColumn('orders', 'status_transaksi', {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    });
  },
  down: async ({ context: queryInterface }) => {
    await queryInterface.changeColumn('orders', 'status_transaksi', {
      type: DataTypes.STRING,
      allowNull: false,
    });
  },
};
