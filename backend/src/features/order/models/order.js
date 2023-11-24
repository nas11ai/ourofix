const { Model, DataTypes } = require('sequelize');

const { sequelize } = require('../../../configs/db');

const DeviceType = require('./device_type');

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
  status: {
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
  },
  response_midtrans: {
    type: DataTypes.TEXT('long'),
    allowNull: true,
  },
  status_transaksi: {
    type: DataTypes.STRING,
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

DeviceType.hasMany(Order, {
  foreignKey: 'device_type_id',
  as: 'orders',
  onDelete: 'CASCADE',
  onUpdate: 'CASCADE',
});

Order.belongsTo(DeviceType, {
  foreignKey: 'device_type_id',
  as: 'device_type',
});

module.exports = Order;
