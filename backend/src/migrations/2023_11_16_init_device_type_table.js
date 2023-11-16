const DataTypes = require('sequelize');

module.exports = {
  up: async ({ context: queryInterface }) => {
    await queryInterface.createTable('device_types', {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        unique: {
          args: true,
          msg: 'ID device telah diambil!',
        },
        allowNull: false,
        validate: {
          notNull: {
            msg: 'ID device tidak boleh kosong!',
          },
        },
      },
      name: {
        type: DataTypes.STRING,
        unique: {
          args: true,
          msg: 'nama sudah digunakan!',
        },
        allowNull: false,
        validate: {
          notNull: {
            msg: 'Masukkan nama device!',
          },
        },
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
    }, {
      uniqueKeys: {
        unique_tag: {
          customIndex: true,
          fields: ['id', 'name'],
        },
      },
    });
  },
  down: async ({ context: queryInterface }) => {
    await queryInterface.dropTable('device_types');
  },
};
