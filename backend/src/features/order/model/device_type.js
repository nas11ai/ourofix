const { Model, DataTypes } = require('sequelize');

const { sequelize } = require('../../../configs/db');

class DeviceType extends Model { }

DeviceType.init({
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
}, {
  sequelize,
  underscored: true,
  timestamps: true,
  modelName: 'DeviceType',
  indexes: [
    {
      unique: true,
      fields: ['id', 'name'],
    },
  ],
});

module.exports = { DeviceType };
