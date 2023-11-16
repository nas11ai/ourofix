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
      msg: 'ID order telah diambil!',
    },
    allowNull: false,
    validate: {
      notNull: {
        msg: 'ID order tidak boleh kosong!',
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
        msg: 'ID order tidak boleh kosong!',
      },
    },
    references: { model: 'device_types', key: 'id' },
    onUpdate: 'CASCADE',
    onDelete: 'CASCADE',
  },
  complains: {
    type: DataTypes.TEXT,
    allowNull: true,
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
