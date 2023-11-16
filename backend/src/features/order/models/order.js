const { Model, DataTypes } = require('sequelize');

const { sequelize } = require('../../../configs/db');

class Order extends Model { }

Order.init({
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
  user_uid: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'Masukkan UID user!',
      },
    },
  },
  device_type_id: {
    type: DataTypes.UUID,
    allowNull: false,
    validate: {
      notNull: {
        msg: 'Order\'s Device Type ID can\'t be empty',
      },
    },
    references: { model: 'device_types', key: 'id' },
    onUpdate: 'CASCADE',
    onDelete: 'CASCADE',
  },
}, {
  sequelize,
  underscored: true,
  timestamps: true,
  modelName: 'Order',
  indexes: [
    {
      unique: true,
      fields: ['id'],
    },
  ],
});

module.exports = Order;
